require 'spec_helper'

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
  it { should be_listening.with('tcp6') }
end

describe port(7199) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end
