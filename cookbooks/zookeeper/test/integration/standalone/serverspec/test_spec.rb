require 'spec_helper'

describe group('zookeeper') do
  it { should exist }
end

describe user('zookeeper') do
  it { should exist }
  it { should belong_to_primary_group 'zookeeper' }
end

describe file('/var/log/zookeeper') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'zookeeper' }
end

describe file('/var/lib/zookeeper') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'zookeeper' }
end

describe service('zookeeper') do
  it { should be_enabled }
  it { should be_running }
end

describe port(2181) do
  it { should be_listening.with('tcp6') }
end
