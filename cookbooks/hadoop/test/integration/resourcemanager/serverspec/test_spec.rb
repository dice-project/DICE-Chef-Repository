require 'spec_helper'

describe group('hadoop') do
  it { should exist }
end

describe user('yarn') do
  it { should exist }
  it { should belong_to_primary_group 'hadoop' }
end

describe file('/var/log/hadoop/yarn') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'yarn' }
  it { should be_grouped_into 'hadoop' }
end

describe file('/var/run/hadoop/yarn') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'yarn' }
  it { should be_grouped_into 'hadoop' }
end

describe service('resourcemanager') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8030) do
  it { should be_listening.with('tcp6') }
end

describe port(8031) do
  it { should be_listening.with('tcp6') }
end

describe port(8032) do
  it { should be_listening.with('tcp6') }
end

describe port(8033) do
  it { should be_listening.with('tcp6') }
end

describe port(8088) do
  it { should be_listening.with('tcp6') }
end
