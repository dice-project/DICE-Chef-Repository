#create new group
group "#{node['dmon_agent']['group']}"

#create new user
user "#{node['dmon_agent']['user']}" do
  group "#{node['dmon_agent']['group']}"
  home "#{node['dmon_agent']['home_dir']}"
  supports :manage_home => true
  system true
  shell '/bin/bash'
end

#download dmon-agent release zip.
remote_file "#{node['dmon_agent']['home_dir']}/dmon-agent.tar.gz" do
  source "#{node['dmon_agent']['tarball']}"
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create_if_missing
end

#extract zip file
execute 'extract' do
  command "tar xvf #{node['dmon_agent']['home_dir']}/dmon-agent.tar.gz"
  cwd "#{node['dmon_agent']['home_dir']}"
  user "#{node['dmon_agent']['user']}"
  not_if { File.exist?("#{node['dmon_agent']['home_dir']}/dmon-agent") }
end

#delete dmon-agent release zip.
file "#{node['dmon_agent']['home_dir']}/dmon-agent.tar.gz" do
  action :delete
end

#create necessary directories
dirs = ['pid', 'log', 'cert', 'lock']

dirs.each do |dir|
  directory "#{node['dmon_agent']['home_dir']}/dmon-agent/#{dir}" do
    owner "#{node['dmon_agent']['user']}"
    group "#{node['dmon_agent']['group']}"
    action :create
  end
end

#install python
python_runtime 'dmonPy' do
  version '2.7'
end

python_virtualenv 'dmonEnv' do
  path "#{node['dmon_agent']['home_dir']}/dmon-agent/dmonEnv"
  python 'dmonPy'
  user "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
end

pip_requirements 'dmonPip' do
  path "#{node['dmon_agent']['home_dir']}/dmon-agent/requirements.txt"
  virtualenv 'dmonEnv'
  user "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  not_if { File.exists?("#{node['dmon_agent']['home_dir']}/dmon-agent/lock/agent.lock") }
end

time =  Time.new.strftime("%Y.%m.%d-%H.%M.%S")
file "#{node['dmon_agent']['home_dir']}/dmon-agent/lock/agent.lock" do
  content "Installed on: #{time}"
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
end

#start the dmon-agent
template '/etc/init/dmon_agent.conf' do
  source 'dmon_agent.conf.erb'
end

service 'dmon_agent' do
  action [ :enable, :start ]
end

# generate node hash
node_hash = {
  :Nodes => [
    :NodeName => node['dmon_agent']['node_name'] ,
    :NodeIP =>  node['ipaddress'],
    :NodeOS => node['platform'],
    :key => "null",
    :username => "null",
    :password => "null"
  ]
}

# includes the given node into the monitored node pools on dmon
http_request 'nodes' do
  action :put
  url "http://#{node['dmon_agent']['dmon']['ip']}:#{node['dmon_agent']['dmon']['port']}/dmon/v1/overlord/nodes"
  message (node_hash.to_json)
  headers({'Content-Type' => 'application/json'})
end
