require 'serverspec'

set :backend, :exec

describe file('/var/log/dmon.log') do
  it { should contain 'DELETE /dmon/v1/overlord/nodes/sample-sample-' }
  it { should contain 'POST /dmon/v2/overlord/core/ls' }
end
