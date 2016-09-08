#install collectd
package 'collectd' do
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

#copy collectd pid
execute 'copy collectd pid' do
  command "cp /run/collectd.pid #{node['dmon_agent']['home_dir']}/dmon-agent/pid/collectd.pid"
  user "#{node['dmon_agent']['user']}"
end
