require 'spec_helper'

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

describe file('/var/lib/hadoop/hdfs/namenode') do
  it { should be_directory }
  it { should be_mode 770 }
  it { should be_owned_by 'hdfs' }
  it { should be_grouped_into 'hadoop' }
end

describe file('/var/lib/hadoop/hdfs/namenode/current/VERSION') do
  it { should be_file }
end

describe service('namenode') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8020) do
  it { should be_listening.with('tcp') }
end

describe port(50_070) do
  it { should be_listening.with('tcp') }
end
