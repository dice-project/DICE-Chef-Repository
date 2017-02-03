resource_name 'set_role'

property :dmon, String
property :role, String, name_property: true
property :hostname, String

action :run do
  http_request "Set #{role} role for node #{hostname}" do
    action :put
    url "http://#{dmon}/dmon/v1/overlord/nodes/roles"
    headers 'Content-Type' => 'application/json'
    message({
      Nodes: [
        NodeName: hostname,
        Roles: [role]
      ]
    }.to_json)
  end

  http_request 'Request Logstash restart' do
    action :post
    url "http://#{dmon}/dmon/v2/overlord/core/ls"
    message ''
    headers 'Content-Type' => 'application/json'
  end
end
