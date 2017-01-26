require 'serverspec'
set :backend, :exec

describe group('hadoop') do
  it { should exist }
end

describe user('hdfs') do
  it { should exist }
  it { should belong_to_primary_group 'hadoop' }
end

describe file('/var/log/hadoop/hdfs') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'hdfs' }
  it { should be_grouped_into 'hadoop' }
end

describe file('/var/run/hadoop/hdfs') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'hdfs' }
  it { should be_grouped_into 'hadoop' }
end

describe file('/var/lib/hadoop/hdfs/datanode') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'hdfs' }
  it { should be_grouped_into 'hadoop' }
end

describe service('datanode') do
  it { should be_enabled }
  it { should be_running }
end

# Next test is ugly, but serverspec has no content_as_xml.
describe file('/etc/hadoop/core-site.xml') do
  its(:content) { should contain 'namenode-ubuntu-1404.node.consul' }
end

describe port(50_010) do
  it { should be_listening.with('tcp') }
end

describe port(50_020) do
  it { should be_listening.with('tcp') }
end

describe port(50_075) do
  it { should be_listening.with('tcp') }
end
