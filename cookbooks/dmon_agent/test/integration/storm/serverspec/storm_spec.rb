require 'serverspec'

set :backend, :exec

describe file('/opt/dmon-agent') do
  it { should be_directory }
end

describe package('collectd') do
  it { should be_installed }
end

describe file('/etc/collectd/collectd.conf') do
  it { should be_file }
  it do
    should contain('10.211.55.100')\
      .from(/<Plugin "network">/).to(%r{</Plugin>})
  end
  it do
    should contain('25826')\
      .from(/<Plugin "network">/).to(%r{</Plugin>})
  end
end

describe service('collectd') do
  it { should be_running }
end

describe file('/var/log/dmon.log') do
  it { should contain 'PUT /dmon/v1/overlord/nodes/roles' }
  it { should contain('storm').from(/Roles/) }
  it { should contain 'POST /dmon/v2/overlord/core/ls' }
end
