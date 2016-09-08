require 'serverspec'

set :backend, :exec

#test for group and user
describe group('ubuntu') do
  it { should exist }
end

describe user('ubuntu') do
  it { should exist }
  it { should belong_to_group 'ubuntu' }
  it { should have_login_shell '/bin/bash' }
end

#test if git was cloned
describe file('/opt/IeAT-DICE-Repository') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

#test if log file was created
describe file('/opt/IeAT-DICE-Repository/src/logs/dmon-controller.log') do
  it { should be_file }
  it { should be_owned_by 'ubuntu' }
end

#test if python virtualenv was created
describe file('/opt/IeAT-DICE-Repository/dmonEnv') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe command('. /opt/IeAT-DICE-Repository/dmonEnv/bin/activate') do
  its(:exit_status) { should eq 0 }
end

#test logstash-forwarder crt and key
describe x509_certificate('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt') do
  it { should be_certificate }
  it { should be_valid }
end

describe x509_private_key('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.key') do
  it { should_not be_encrypted }
  it { should be_valid }
  it { should have_matching_certificate('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt') }
end

#test if dmon-agent is installed and running
describe file('/etc/init/dmon.conf') do
  it { should be_file }
  it { should contain('/opt/IeAT-DICE-Repository').from(/DIR/).to(/setuid/) }
  it { should contain('ubuntu').from(/setuid/).to(/setgid/) }
  it { should contain('ubuntu').from(/setgid/).to(/script/) }
  it { should contain('5001').from(/script/).to(/end/) }
end

describe service('dmon') do
  it { should be_running }
end

#test if kibana was installed
describe file("/opt/kibana") do
  it { should be_directory }
end

describe service('kibana4') do
  it { should be_enabled }
end

#test if elasticsearch was installed
describe file("/opt/elasticsearch") do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe file("/opt/elasticsearch/config/elastcisearch.yml") do
  it { should_not exist }
end

#test if logstash was installed
describe file("/opt/logstash") do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe file("/opt/IeAT-DICE-Repository/src/logs/logstash.log") do
  it { should be_file }
  it { should be_owned_by 'ubuntu' }
end

#test if elk is running
pids = ['elasticsearch.pid', 'kibana.pid', 'logstash.pid']
pids.each do |pid|
  describe file("/opt/IeAT-DICE-Repository/src/pid/#{pid}") do
    it { should be_file }
  end
end
