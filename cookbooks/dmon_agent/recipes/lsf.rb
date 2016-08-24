#add logstash-forwarder repository definition
apt_repository 'logstash-forwarder' do
  uri 'http://packages.elasticsearch.org/logstashforwarder/debian'
  components ['main']
  distribution 'stable'
  key 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
end


#install logstash-forwarder
package 'logstash-forwarder' do
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
service 'logstash-forwarder' do
  action :start
end

