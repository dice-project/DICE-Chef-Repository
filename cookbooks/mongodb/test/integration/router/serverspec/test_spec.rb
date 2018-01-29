require 'serverspec'
set :backend, :exec

hosts = 'config_replica/host1:27017,host2:27017,host3:27017'

describe file('/etc/mongod.conf') do
  its(:content_as_yaml) do
    should include('net' => include('bindIp' => '0.0.0.0'))
    should include('sharding' => include('configDB' => hosts))
  end
end

describe service('mongod') do
  it { should_not be_enabled }
end

# This will check if service is present
describe service('mongos') do
  it { should_not be_enabled }
end
