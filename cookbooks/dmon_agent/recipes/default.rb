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

#install collectd
include_recipe 'dmon_agent::collectd'

#install and configure additional packages appropriate to node role
node['dmon_agent']['roles'].each do |role|
  case role
  when 'storm'
  when 'kafka'    
  when 'spark'
    include_recipe 'dmon_agent::spark'
  when 'yarn', 'hdfs'
    include_recipe 'dmon_agent::lsf'
  end
end

#install dmon_agent
include_recipe 'dmon_agent::agent'
