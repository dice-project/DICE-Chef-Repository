require 'serverspec'

set :backend, :exec

#test for group and user
describe group('dmon-agent') do
  it { should exist }
end

describe user('dmon-agent') do
  it { should exist }
  it { should belong_to_group 'dmon-agent' }
  it { should have_home_directory '/home/dmon-agent' }
  it { should have_login_shell '/bin/bash' }
end

#test if Collectd is successfully installed, configured and started.
describe package('collectd') do
  it { should be_installed }
end

describe file('/etc/collectd/collectd.conf') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
  it { should contain('10.211.55.100').from(/<Plugin "network">/).to(/<\/Plugin>/) }
  it { should contain('25826').from(/<Plugin "network">/).to(/<\/Plugin>/) }
end

describe service('collectd') do
  it { should be_running }
end

#test if spark is configured.
describe file('/etc/spark/metrics.properties') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
  it { should contain('10.211.55.100').from(/host/).to(/host/) }
  it { should contain('5002').from(/host/).to(/period/) }
  it { should contain('5').from(/period/).to(/seconds/) }
end

#test if dmon-agent was downloaded
describe file('/home/dmon-agent/dmon-agent') do
  it { should be_directory }
  it { should be_owned_by 'dmon-agent' }
end

#test if necessary directorys were created
dirs = ['pid', 'log', 'cert', 'lock']
dirs.each do |dir|
  describe file("/home/dmon-agent/dmon-agent/#{dir}") do
    it { should be_directory }
    it { should be_owned_by 'dmon-agent' }
  end
end

#test if collectd.pid was copied
describe file('/home/dmon-agent/dmon-agent/pid/collectd.pid') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
end

#test if python virtualenv was created
describe file('/home/dmon-agent/dmon-agent/dmonEnv') do
  it { should be_directory }
  it { should be_owned_by 'dmon-agent' }
end

describe command('. /home/dmon-agent/dmon-agent/dmonEnv/bin/activate') do
  its(:exit_status) { should eq 0 }
end

#test if python packages were installed
describe file('/home/dmon-agent/dmon-agent/lock/agent.lock') do
  it { should be_file }
end

#test if dmon-agent is installed and running
describe file('/etc/init/dmon_agent.conf') do
  it { should be_file }
  it { should contain('/home/dmon-agent').from(/DIR/).to(/dmon-agent/) }
  it { should contain('dmon-agent').from(/setuid/).to(/setgid/) }
  it { should contain('dmon-agent').from(/setgid/).to(/script/) }
end

describe service('dmon_agent') do
  it { should be_running }
end
