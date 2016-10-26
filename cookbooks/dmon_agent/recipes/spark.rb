# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_master = node['cloudify']['properties']['monitoring']['dmon_address']
dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']

spark_conf_dir = node['spark']['spark-env']['SPARK_CONF_DIR']

graphite_address =
  node['cloudify']['properties']['monitoring']['logstash_graphite_address']
graphite_host, graphite_port = graphite_address.split ':'
graphite_period = node['dmon_agent']['spark']['graphite']['period']

template "#{spark_conf_dir}/metrics.properties" do
  source 'spark-metrics.tmp.erb'
  # Next two lines are here to support dmon agent modifications
  owner dmon_user
  group dmon_group
  action :create
  variables host: graphite_host, port: graphite_port, period: graphite_period
end

# Role registration data
role_hash = {
  Nodes: [
    NodeName: node['hostname'],
    Roles: ['spark']
  ]
}

http_request 'roles' do
  action :put
  url "http://#{dmon_master}/dmon/v1/overlord/nodes/roles"
  message role_hash.to_json
  headers 'Content-Type' => 'application/json'
end

http_request 'Request Logstash restart on dmon master' do
  action :post
  url "http://#{dmon_master}/dmon/v1/overlord/core/ls"
  message {}.to_json
  headers 'Content-Type' => 'application/json'
end
