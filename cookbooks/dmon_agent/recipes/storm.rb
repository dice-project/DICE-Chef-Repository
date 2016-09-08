# generate role hash
role_hash = {
  :Nodes => [
    :NodeName => node['dmon_agent']['node_name'],
    :Roles => ['storm']
  ]
}

# add a role to the node
http_request 'roles' do
  action :put
  url "http://#{node['dmon_agent']['dmon']['ip']}:#{node['dmon_agent']['dmon']['port']}/dmon/v1/overlord/nodes/roles"
  message (role_hash.to_json)
  headers({'Content-Type' => 'application/json'})
end
