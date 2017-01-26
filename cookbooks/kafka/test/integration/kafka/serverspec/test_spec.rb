require 'serverspec'
set :backend, :exec

describe group('kafka') do
  it { should exist }
end

describe user('kafka') do
  it { should exist }
  it { should belong_to_primary_group 'kafka' }
end

describe file('/var/log/kafka') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'kafka' }
end

describe file('/var/lib/kafka') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'kafka' }
end

# Cannot start kafka without zookeeper, so there is no running instance.
