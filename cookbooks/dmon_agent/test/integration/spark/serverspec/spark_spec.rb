require 'serverspec'

set :backend, :exec

describe group('dmon-agent') do
  it { should exist }
end

describe user('dmon-agent') do
  it { should exist }
  it { should belong_to_group 'dmon-agent' }
  it { should have_home_directory '/home/dmon-agent' }
  it { should have_login_shell '/bin/bash' }
end

describe file('/home/dmon-agent/dmon-agent') do
  it { should be_directory }
  it { should be_owned_by 'dmon-agent' }
end

%w(pid log cert lock).each do |dir|
  describe file("/home/dmon-agent/dmon-agent/#{dir}") do
    it { should be_directory }
    it { should be_owned_by 'dmon-agent' }
  end
end

describe file('/home/dmon-agent/dmon-agent/dmonEnv') do
  it { should be_directory }
  it { should be_owned_by 'dmon-agent' }
end

describe command('. /home/dmon-agent/dmon-agent/dmonEnv/bin/activate') do
  its(:exit_status) { should eq 0 }
end

describe file('/home/dmon-agent/dmon-agent/lock/agent.lock') do
  it { should be_file }
end

describe file('/etc/init/dmon_agent.conf') do
  it { should be_file }
  it { should contain('/home/dmon-agent').from(/DIR/).to(/dmon-agent/) }
  it { should contain('dmon-agent').from(/setuid/).to(/setgid/) }
  it { should contain('dmon-agent').from(/setgid/).to(/script/) }
end

describe service('dmon_agent') do
  it { should be_running }
end

describe file('/var/log/dmon.log') do
  it { should be_file }
  it { should contain 'PUT /dmon/v1/overlord/nodes' }
end

describe package('collectd') do
  it { should be_installed }
end

describe file('/etc/collectd/collectd.conf') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
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

describe file('/home/dmon-agent/dmon-agent/pid/collectd.pid') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
end

describe file('/tmp/metrics.properties') do
  it { should be_file }
  it { should contain('10.211.55.100').from(/host/).to(/port/) }
  it { should contain('5002').from(/port/).to(/period/) }
  it { should contain('5').from(/period/).to(/unit/) }
end

describe file('/var/log/dmon.log') do
  it { should contain 'PUT /dmon/v1/overlord/nodes/roles' }
  it { should contain('spark').from(/Roles/) }
  it { should contain 'POST /dmon/v1/overlord/core/ls' }
end
