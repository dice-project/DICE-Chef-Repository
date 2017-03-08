resource_name 'remove_node'

property :dmon, String
property :hostname, String, name_property: true

action :run do
  http_request "Remove node #{hostname} from DMon master" do
    action :delete
    url "http://#{dmon}/dmon/v1/overlord/nodes/#{hostname}"
    message ''
    headers 'Content-Type' => 'application/json'
  end

  http_request 'Request Logstash restart (node removal)' do
    action :post
    url "http://#{dmon}/dmon/v2/overlord/core/ls"
    message ''
    headers 'Content-Type' => 'application/json'
  end
end
