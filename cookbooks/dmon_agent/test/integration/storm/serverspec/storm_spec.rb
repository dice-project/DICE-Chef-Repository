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

describe file('/etc/init/dmon-agent.conf') do
  it { should exist }
  it { should be_file }
  it { should contain('setuid root') }
  it { should contain('setgid root') }
  it { should contain('/opt/dmon-agent/dmon-agent.py') }
end

describe file('/opt/dmon-agent/dmon-agent.py') do
  it { should be_file }
end

['log', 'cert'].each do |dir|
  describe file("/opt/dmon-agent/#{dir}") do
    it { should exist }
    it { should be_directory }
  end
end

describe file('/opt/dmon-agent/dmonEnv/bin/activate') do
  it { should exist }
  it { should be_file }
end

describe service('dmon-agent') do
  it { should be_running }
end

describe file('/etc/default/dmon-agent.d') do
  it { should exist }
  it { should be_directory }
end

describe file('/etc/default/dmon-agent.d/storm') do
  it { should exist }
  it { should be_file }
  it { should contain('STORM_VERSION=1.0') }
  it { should contain('STORM_LOG=/usr/share/storm/logs') }
end
