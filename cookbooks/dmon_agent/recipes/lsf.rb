# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']

apt_repository 'logstash-forwarder' do
  uri 'http://packages.elasticsearch.org/logstashforwarder/debian'
  components ['main']
  distribution 'stable'
  key 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
end

package 'logstash-forwarder' do
  action :install
end

directory '/opt/certs' do
  owner dmon_user
  group dmon_group
  action :create
end

file '/opt/certs/logstash-forwarder.crt' do
  content node['dmon_agent']['logstash']['lsf_crt']
  owner dmon_user
  group dmon_group
  action :create
end

template '/etc/logstash-forwarder.conf' do
  source 'logstash-forwarder.conf.erb'
  owner dmon_user
  group dmon_group
  action :create
end

service 'logstash-forwarder' do
  action :start
end
