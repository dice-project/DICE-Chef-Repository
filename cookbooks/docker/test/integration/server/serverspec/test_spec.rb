require 'serverspec'
set :backend, :exec

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe port(2375) do
  it { should be_listening.with('tcp') }
end

describe command('docker run hello-world') do
  its(:exit_status) { should eq 0 }
end
