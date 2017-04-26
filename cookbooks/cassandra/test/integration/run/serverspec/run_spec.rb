require 'serverspec'
set :backend, :exec

describe group('cassandra') do
  it { should exist }
end

describe user('cassandra') do
  it { should exist }
  it { should belong_to_primary_group 'cassandra' }
end

describe file('/var/log/cassandra') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'cassandra' }
end

describe file('/var/lib/cassandra') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'cassandra' }
end

describe service('cassandra') do
  it { should be_enabled }
  it { should be_running }
end

describe port(7000) do
  it { should be_listening.with('tcp') }
end

describe port(9160) do
  it { should be_listening.with('tcp') }
end

describe port(9042) do
  it { should be_listening.with('tcp') }
end

describe port(7199) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe file('/usr/bin/cqlsh') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe command('cqlsh --help') do
  its(:exit_status) { should eq 0 }
end
