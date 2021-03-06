require 'serverspec'
set :backend, :exec

describe file('/etc/mongod.conf') do
  its(:content_as_yaml) do
    should include('net' => include('bindIp' => '0.0.0.0'))
    should include('replication' => include('replSetName' => 'shard_replica'))
    should include('sharding' => include('clusterRole' => 'shardsvr'))
  end
end
