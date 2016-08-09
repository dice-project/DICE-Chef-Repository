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

#append to host
execute 'host' do
  command "echo \"127.0.1.1 #{node['hostname']} #{node['hostname']}\" >> /etc/hosts"
end

#install collectd
package 'collectd'  do
  action :install
end

#upload collectd conf file
template '/etc/collectd/collectd.conf' do
  source 'collectd.conf.erb'
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
end

#restart collectd
service 'collectd' do
  action :restart
end


#add logstash-forwarder repository definition
apt_repository 'logstash-forwarder' do
  uri 'http://packages.elasticsearch.org/logstashforwarder/debian'
  components ['main']
  distribution 'stable'
  key 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
end


#install logstash-forwarder
package 'logstash-forwarder'  do
  action :install
end

#create certificate directory
directory '/opt/certs' do
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
end

#upload logstash-forwarder certificate
file '/opt/certs/logstash-forwarder.crt' do
  content "#{node['dmon_agent']['logstash']['lsf_crt']}"
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
end

#upload logstash-forwarder conf file
template '/etc/logstash-forwarder.conf' do
  source 'logstash-forwarder.conf.erb'
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
end

#restart logstash-forwarder
service 'logstash-forwarder'  do
  action :start
end

#install python
package ['python-dev', 'python-pip']  do
  action :install
end

#download dmon-agent release zip.
remote_file "#{node['dmon_agent']['home_dir']}/dmon-agent.tar.gz" do
  source "#{node['dmon_agent']['git_url']}"
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

#create necessary directorys
dirs = ['pid', 'log', 'cert', 'lock']

dirs.each do |dir|
  directory "#{node['dmon_agent']['home_dir']}/dmon-agent/#{dir}" do
    owner "#{node['dmon_agent']['user']}"
    group "#{node['dmon_agent']['group']}"
    action :create
  end
end

#copy collectd pid
execute 'copy collectd pid' do
  command "cp /run/collectd.pid #{node['dmon_agent']['home_dir']}/dmon-agent/pid/collectd.pid"
  user "#{node['dmon_agent']['user']}"
end


#install python packages
bash 'install python packages' do
  cwd "#{node['dmon_agent']['home_dir']}/dmon-agent"
  code <<-EOH
  currentDate=$(date "+%Y.%m.%d-%H.%M.%S")
  pip install -r requirements.txt
  echo "Installed on: $currentDate" >> lock/agent.lock
  EOH
  not_if { File.exists?("#{node['dmon_agent']['home_dir']}/dmon-agent/lock/agent.lock") }
end

#start the dmon-agent
bash 'start dmon-agent' do
  user "#{node['dmon_agent']['user']}"
  cwd "#{node['dmon_agent']['home_dir']}/dmon-agent"
  code <<-EOH
  nohup python dmon-agent.py > log/dmon-agent.out 2>&1 &
  echo $! > pid/dmon-agent.pid
  EOH
  not_if { File.exists?("#{node['dmon_agent']['home_dir']}/dmon-agent/pid/dmon-agent.pid") }
end
