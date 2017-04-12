require 'serverspec'
set :backend, :exec

describe service('mongod') do
  it { should be_enabled }
  it { should be_running }
end

describe port(27_017) do
  it { should be_listening.with('tcp') }
end
