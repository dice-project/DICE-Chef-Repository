#append to host
execute 'host' do
  command "echo \"127.0.1.1 #{node['hostname']} #{node['hostname']}\" >> /etc/hosts"
end

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
