require 'serverspec'
set :backend, :exec

describe file('/etc/mongod.conf') do
  its(:content_as_yaml) do
    should include('security' => include('authorization' => 'enabled'))
  end
end

describe service('mongod') do
  it { should be_enabled }
  it { should be_running }
end

describe port(27_017) do
  it { should be_listening.with('tcp') }
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe command("mongo --eval 'db.foo.insert({x:3})'") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /"code"\s*:\s*13/ }
end
