require 'spec_helper'

describe group('spark') do
  it { should exist }
end

describe user('spark') do
  it { should exist }
  it { should belong_to_primary_group 'spark' }
end

describe file('/var/log/spark-2.0') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'spark' }
end

describe file('/var/lib/spark-2.0') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'spark' }
end

describe file('/etc/spark-2.0') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe service('spark-master-2.0') do
  it { should be_enabled }
  it { should be_running }
end

describe port(6066) do
  it { should be_listening.with('tcp6') }
end

describe port(7077) do
  it { should be_listening.with('tcp6') }
end

describe port(8080) do
  it { should be_listening.with('tcp6') }
end

# Test for wrapper creation
%w(pyspark sparkR spark-shell spark-sql spark-submit).each do |cmd|
  describe file("/usr/bin/#{cmd}") do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe command("#{cmd} --help") do
    its(:exit_status) { should eq 0 }
  end
end
