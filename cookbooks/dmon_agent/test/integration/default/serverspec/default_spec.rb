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

#test if Logstash-forwarder is successfully installed, configured and started.
describe package('logstash-forwarder') do
  it { should be_installed }
end

describe file('/opt/certs') do
  it { should be_directory }
  it { should be_owned_by 'dmon-agent' }
end

describe file('/opt/certs/logstash-forwarder.crt') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
end

describe x509_certificate('/opt/certs/logstash-forwarder.crt') do
  it { should be_certificate }
  it { should be_valid }
end

describe file('/etc/logstash-forwarder.conf') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
  it { should contain('10.211.55.100').from(/servers/).to(/timeout/) }
  it { should contain('5000').from(/servers/).to(/timeout/) }
end

describe service('logstash-forwarder') do
  it { should be_running }
end

#test if python was installed
describe package('python-dev') do
  it { should be_installed }
end

describe package('python-pip') do
  it { should be_installed }
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

#test if python packages were installed
describe file('/home/dmon-agent/dmon-agent/lock/agent.lock') do
  it { should be_file }
end

#test if dmo-agent is running
describe file('/home/dmon-agent/dmon-agent/pid/dmon-agent.pid') do
  it { should be_file }
end
