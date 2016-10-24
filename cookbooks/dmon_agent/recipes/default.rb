# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_master = node['cloudify']['properties']['monitoring']['dmon_address']
dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']
dmon_home = node['dmon_agent']['home_dir']
dmon_install_dir = node['dmon_agent']['install_dir']

group dmon_group

user dmon_user do
  group dmon_group
  home dmon_home
  supports manage_home: true
  system true
  shell '/bin/bash'
end

# NOTE: Basename dmon_agent.tar is NOT a typo. Even if default attributes say
# that node['dmon_agent']['tarball'] is gzipped tarball, this is not true (we
# learned that fact the hard way).
dmon_tar = "#{Chef::Config[:file_cache_path]}/dmon_agent.tar"
remote_file dmon_tar do
  source node['dmon_agent']['tarball']
  checksum node['dmon_agent']['checksum']
  action :create
end

poise_archive dmon_tar do
  destination dmon_install_dir
end

execute 'Update agent folder ownership' do
  command "chown -R #{dmon_user}:#{dmon_group} #{dmon_install_dir}"
end

%w(pid log cert lock).each do |dir|
  directory "#{dmon_install_dir}/#{dir}" do
    owner dmon_user
    group dmon_group
    action :create
  end
end

python_runtime 'dmonPy' do
  version '2.7'
end

python_virtualenv 'dmonEnv' do
  path "#{dmon_install_dir}/dmonEnv"
  python 'dmonPy'
  user dmon_user
  group dmon_group
end

pip_requirements 'dmonPip' do
  path "#{dmon_install_dir}/requirements.txt"
  virtualenv 'dmonEnv'
  user dmon_user
  group dmon_group
  not_if { File.exist? "#{dmon_install_dir}/lock/agent.lock" }
end

time = Time.new.strftime('%Y.%m.%d-%H.%M.%S')
file "#{dmon_install_dir}/lock/agent.lock" do
  content "Installed on: #{time}"
  owner dmon_user
  group dmon_group
end

template '/etc/init/dmon_agent.conf' do
  source 'dmon_agent.conf.erb'
end

service 'dmon_agent' do
  action [:enable, :start]
end

# Node registration data
node_hash = {
  Nodes: [
    NodeName: node['hostname'],
    NodeIP: node['ipaddress'],
    NodeOS: node['platform'],
    key: 'null',
    username: 'null',
    password: 'null'
  ]
}

# Register node on dmon master
http_request 'nodes' do
  action :put
  url "http://#{dmon_master}/dmon/v1/overlord/nodes"
  message node_hash.to_json
  headers 'Content-Type' => 'application/json'
end
