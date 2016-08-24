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
