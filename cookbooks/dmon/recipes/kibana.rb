#create new group
group "#{node['dmon']['group']}"

#create new user
user "#{node['dmon']['user']}" do
  group "#{node['dmon']['group']}"
  system true
  shell '/bin/bash'
end

# Install kibana
remote_file '/opt/kibana-4.4.1-linux-x64.tar.gz' do
  source "#{node['dmon']['kb']['source']}"
  action :create_if_missing
end

directory '/opt/kibana' do
  action :create
end

execute 'extract kibana' do
  command 'tar xvf kibana-4.4.1-linux-x64.tar.gz -C kibana --strip-components=1'
  cwd '/opt'
  not_if { ::File.directory?('/opt/kibana/bin') }
end

# Install Marvel
execute 'install marvel' do
  command '/opt/kibana/bin/kibana plugin --install elasticsearch/marvel/2.2.0'
end

file '/opt/kibana-4.4.1-linux-x64.tar.gz' do
  action :delete
end

directory "#{node['dmon']['install_dir']}/src/pid" do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  recursive true
  action :create
end

directory "#{node['dmon']['install_dir']}/src/logs" do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  recursive true
  action :create
end

#upload kibana conf file
template "/opt/kibana/config/kibana.yml" do
  source 'kibana.tmp.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :kbPort => node['dmon']['kb']['port'],
    :esIp => node['dmon']['es']['ip'],
    :esPort => node['dmon']['es']['port'],
    :kibanaPID => "#{node['dmon']['install_dir']}/src/pid/kibana.pid",
    :kibanaLog => "#{node['dmon']['install_dir']}/src/logs/kibana.log"
  })
end

execute 'setting permissions' do
  command "chown -R #{node['dmon']['user']}.#{node['dmon']['group']} /opt/kibana"
end

#start kibana
bash 'start kibana' do
  code <<-EOH
    nohup /opt/kibana/bin/kibana &
    pid=$!
    echo $pid > #{node['dmon']['install_dir']}/src/pid/kibana.pid
    EOH
  user "#{node['dmon']['user']}"
end

