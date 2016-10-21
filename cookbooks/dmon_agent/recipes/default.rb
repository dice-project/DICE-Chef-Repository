# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_master = node['cloudify']['properties']['monitoring']['dmon_address']
dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']
dmon_home = node['dmon_agent']['home_dir']

group dmon_group

user dmon_user do
  group dmon_group
  home dmon_home
  supports manage_home: true
  system true
  shell '/bin/bash'
end

dmon_tar = "#{Chef::Config[:file_cache_path]}/kafka.tar.gz"
remote_file dmon_tar do
  source node['dmon_agent']['tarball']
  action :create_if_missing
end

execute 'extract' do
  command "tar xvf #{dmon_tar}"
  cwd dmon_home
  user dmon_user
  not_if { File.exist?("#{dmon_home}/dmon-agent") }
end

%w(pid log cert lock).each do |dir|
  directory "#{dmon_home}/dmon-agent/#{dir}" do
    owner dmon_user
    group dmon_group
    action :create
  end
end

python_runtime 'dmonPy' do
  version '2.7'
end

python_virtualenv 'dmonEnv' do
  path "#{dmon_home}/dmon-agent/dmonEnv"
  python 'dmonPy'
  user dmon_user
  group dmon_group
end

pip_requirements 'dmonPip' do
  path "#{dmon_home}/dmon-agent/requirements.txt"
  virtualenv 'dmonEnv'
  user dmon_user
  group dmon_group
  not_if { File.exist? "#{dmon_home}/dmon-agent/lock/agent.lock" }
end

time = Time.new.strftime('%Y.%m.%d-%H.%M.%S')
file "#{dmon_home}/dmon-agent/lock/agent.lock" do
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
