# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']
dmon_home = node['dmon_agent']['home_dir']

package 'collectd' do
  action :install
end

template '/etc/collectd/collectd.conf' do
  source 'collectd.conf.erb'
  owner dmon_user
  group dmon_group
  action :create
end

service 'collectd' do
  action :restart
end

execute 'copy collectd pid' do
  command "cp /run/collectd.pid #{dmon_home}/dmon-agent/pid/collectd.pid"
  user dmon_user
end
