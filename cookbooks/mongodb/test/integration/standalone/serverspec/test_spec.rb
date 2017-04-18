require 'serverspec'
set :backend, :exec

describe service('mongod') do
  it { should be_enabled }
  it { should be_running }
end

describe port(27_017) do
  it { should be_listening.with('tcp') }
  it { should be_listening.on('127.0.0.1').with('tcp') }
end
