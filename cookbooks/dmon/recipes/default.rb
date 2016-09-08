#create new group
group "#{node['dmon']['group']}"

#create new user
user "#{node['dmon']['user']}" do
  group "#{node['dmon']['group']}"
  system true
  shell '/bin/bash'
end

#clone git repository 
git "#{node['dmon']['install_dir']}" do
  repository "#{node['dmon']['git_url']}"
  revision 'master'
  action :sync
  not_if { File.exist?("#{node['dmon']['install_dir']}") }
end

execute 'setting permissions' do
  command "chown -R #{node['dmon']['user']}.#{node['dmon']['group']} #{node['dmon']['install_dir']}"
end

#create empty dmon-controller log file
file "#{node['dmon']['install_dir']}/src/logs/dmon-controller.log" do
  content ''
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  not_if { File.exist?("#{node['dmon']['install_dir']}/src/logs/dmon-controller.log") }
end

#install python
python_runtime 'dmonPy' do
  version '2.7'
end

python_virtualenv 'dmonEnv' do
  path "#{node['dmon']['install_dir']}/dmonEnv"
  python 'dmonPy'
  user "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
end

pip_requirements 'dmonPip' do
  path "#{node['dmon']['install_dir']}/src/requirements.txt"
  virtualenv 'dmonEnv'
  user "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
end

#start the dmon
template '/etc/init/dmon.conf' do
  source 'dmon.conf.erb'
end

service 'dmon' do
  action [ :enable, :start ]
end
