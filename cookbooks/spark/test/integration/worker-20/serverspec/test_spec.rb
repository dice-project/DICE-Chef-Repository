require 'serverspec'
set :backend, :exec

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

describe file('/etc/init/spark-worker-2.0.conf') do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should contain 'start-slave.sh' }
end
