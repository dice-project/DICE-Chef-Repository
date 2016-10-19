# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_master = [
  node['dmon_agent']['dmon']['ip'],
  node['dmon_agent']['dmon']['port']
].join ':'

dmon_user = node['dmon_agent']['user']
dmon_group = node['dmon_agent']['group']

spark_conf_dir = node['spark']['spark-env']['SPARK_CONF_DIR']

template "#{spark_conf_dir}/metrics.properties" do
  source 'spark-metrics.tmp.erb'
  # Next two lines are here to support dmon agent modifications
  owner dmon_user
  group dmon_group
  action :create
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
