spark_conf_dir = node['spark']['spark-env']['SPARK_CONF_DIR']

template "#{spark_conf_dir}/metrics.properties" do
  source 'spark-metrics.tmp.erb'
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
end

# generate role hash
role_hash = {
  :Nodes => [
    :NodeName => node['hostname'],
    :Roles => ['spark']
  ]
}

# add a role to the node
http_request 'roles' do
  action :put
  url "http://#{node['dmon_agent']['dmon']['ip']}:#{node['dmon_agent']['dmon']['port']}/dmon/v1/overlord/nodes/roles"
  message (role_hash.to_json)
  headers({'Content-Type' => 'application/json'})
end
