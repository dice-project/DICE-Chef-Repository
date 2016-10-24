# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']
dmon_install_dir = node['dmon_agent']['install_dir']
logstash_udp_address =
  node['cloudify']['properties']['monitoring']['logstash_udp_address']
logstash_udp_host, logstash_udp_port = logstash_udp_address.split ':'

package 'collectd' do
  action :install
end

template '/etc/collectd/collectd.conf' do
  source 'collectd.conf.erb'
  owner dmon_user
  group dmon_group
  action :create
  variables host: logstash_udp_host, port: logstash_udp_port
end

service 'collectd' do
  action :restart
end

execute 'copy collectd pid' do
  command "cp /run/collectd.pid #{dmon_install_dir}/pid/collectd.pid"
  user dmon_user
end
