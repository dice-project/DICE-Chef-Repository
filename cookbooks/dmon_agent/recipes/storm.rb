# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_master = [
  node['dmon_agent']['dmon']['ip'],
  node['dmon_agent']['dmon']['port']
].join ':'

# Generate role hash
role_hash = {
  Nodes: [
    NodeName: node['hostname'],
    Roles: ['storm']
  ]
}

# Add a role to the node
http_request 'roles' do
  action :put
  url "http://#{dmon_master}/dmon/v1/overlord/nodes/roles"
  message role_hash.to_json
  headers 'Content-Type' => 'application/json'
end
