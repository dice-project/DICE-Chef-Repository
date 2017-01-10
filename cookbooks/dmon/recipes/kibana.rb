
install_dir = node['dmon']['kb']['install_dir']
dmon_user = node['dmon']['user']
dmon_group = node['dmon']['group']

kb_tar = "#{Chef::Config[:file_cache_path]}/kb.tar.gz"
remote_file kb_tar do
  source node['dmon']['kb']['source']
  checksum node['dmon']['kb']['checksum']
end

poise_archive kb_tar do
  destination install_dir
end

bash 'Install marvel' do
  code <<-EOH
    cd #{install_dir}/bin
    ./kibana plugin --install elasticsearch/marvel/2.2.0
    EOH
end

template "#{install_dir}/config/kibana.yml" do
  source 'kibana.tmp.erb'
  owner dmon_user
  group dmon_group
  action :create
  variables(
    kbPort: node['dmon']['kb']['port'],
    esIp: node['dmon']['es']['ip'],
    esPort: node['dmon']['es']['port'],
    kibanaPID: "#{node['dmon']['install_dir']}/src/pid/kibana.pid",
    kibanaLog: "#{node['dmon']['install_dir']}/src/logs/kibana.log"
  )
end

execute 'Setting Kibana permissions' do
  command "chown -R #{dmon_user}:#{dmon_group} #{install_dir}"
end

# Copy init script (Chef does not have copy block for some reason)
remote_file 'Copy Kibana service file' do
  path '/etc/init.d/kibana4'
  source "file://#{node['dmon']['install_dir']}/src/init/kibana4"
  owner 'root'
  group 'root'
  mode 0755
end

ruby_block 'Patch broken kibana service file' do
  block do
    fe = Chef::Util::FileEdit.new('/etc/init.d/kibana4')
    fe.insert_line_after_match(/KIBANA_BIN/,
                               'DMONHOME=/opt/IeAT-DICE-Repository')
    fe.write_file
  end
end

service 'kibana4' do
  action [:enable, :start]
end
