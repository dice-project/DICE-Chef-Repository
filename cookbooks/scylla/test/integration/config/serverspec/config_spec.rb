require 'spec_helper'

describe file('/etc/scylla/scylla.yaml') do
  it { should be_file }
  its(:content_as_yaml) do
    should include('listen_address' => '123.135.147.159')
  end
  its(:content_as_yaml) do
    should include('rpc_address' => '0.0.0.0')
  end
  its(:content_as_yaml) do
    should include('broadcast_rpc_address' => '123.135.147.159')
  end
  its(:content_as_yaml) do
    should include(
      'seed_provider' => include(
        'class_name' => 'org.apache.cassandra.locator.SimpleSeedProvider',
        'parameters' => include(
          'seeds' => '111.11.1.123,111.11.1.124'
        )
      )
    )
  end
  its(:content_as_yaml) do
    should include('conf_1' => 'string_value')
  end
  its(:content_as_yaml) do
    should include('conf_2' => 123)
  end
  its(:content_as_yaml) do
    should include(
      'conf_3' => include(
        'this' => 'is',
        'nested' => 'dict',
        'with' => %w(array of strings)
      )
    )
  end
end

describe file('/etc/scylla/cassandra-rackdc.properties') do
  it { should be_file }
end
