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

describe file('/var/lib/hadoop/yarn/local') do
  it { should be_directory }
  it { should be_mode 770 }
  it { should be_owned_by 'yarn' }
  it { should be_grouped_into 'hadoop' }
end

describe file('/var/log/hadoop/yarn/userlogs') do
  it { should be_directory }
  it { should be_mode 770 }
  it { should be_owned_by 'yarn' }
  it { should be_grouped_into 'hadoop' }
end

describe service('nodemanager') do
  it { should be_enabled }
  it { should be_running }
end

# Next tests are ugly, but serverspec has no content_as_xml.
describe file('/etc/hadoop/yarn-site.xml') do
  its(:content) { should contain 'resourcemanager-ubuntu-1404.node.consul' }
end

describe file('/etc/hadoop/core-site.xml') do
  its(:content) { should contain 'namenode-ubuntu-1404.node.consul' }
end

describe port(8040) do
  it { should be_listening.with('tcp6') }
end

describe port(8042) do
  it { should be_listening.with('tcp6') }
end

# Test for wrapper creation
%w(hadoop hdfs yarn).each do |cmd|
  describe file("/usr/bin/#{cmd}") do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
