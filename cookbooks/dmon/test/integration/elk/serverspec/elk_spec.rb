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

#test if dmon is installed and running
describe file('/etc/init/dmon.conf') do
  it { should be_file }
  it { should contain('/opt/IeAT-DICE-Repository').from(/DIR/).to(/setuid/) }
  it { should contain('ubuntu').from(/setuid/).to(/setgid/) }
  it { should contain('ubuntu').from(/setgid/).to(/script/) }
  it { should contain('5001').from(/script/).to(/end/) }
end

describe service('dmon') do
  it { should be_enabled }
  it { should be_running }
end


#test if elasticsearch was installed
describe file("/opt/elasticsearch") do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

#test if elasticsearch was correctly configured
describe file('/opt/elasticsearch/config/elasticsearch.yml') do
  it { should be_file }
  it { should contain('diceMonit').from(/cluster.name:/).to(/#/) }
  it { should contain('esCoreMaster').from(/node.name:/).to(/#/) }
  it { should contain('/opt/IeAT-DICE-Repository/src/logs').from(/path.logs:/).to(/#/) }
end


#test if kibana was installed
describe file("/opt/kibana") do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

#test if kibana was correctly configured
describe file('/opt/kibana/config/kibana.yml') do
  it { should be_file }
  it { should contain('5601').from(/server.port:/).to(/#/) }
  it { should contain('127.0.0.1').from(/elasticsearch.url:/).to(/#/) }
  it { should contain('9200').from(/elasticsearch.url:/).to(/#/) }
  it { should contain('/opt/IeAT-DICE-Repository/src/pid/kibana.pid').from(/pid.file:/).to(/#/) }
  it { should contain('/opt/IeAT-DICE-Repository/src/logs/kibana.log').from(/logging.dest:/).to(/#/) }
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

#test if kibana was correctly configured
describe file('/opt/IeAT-DICE-Repository/src/conf/logstash.conf') do
  it { should be_file }
  it { should contain('5000').from(/lumberjack/).to(/ssl_certificate/) }
  it { should contain('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt').from(/ssl_certificate/).to(/ssl_key/) }
  it { should contain('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.key').from(/ssl_key/).to(/graphite/) }
  it { should contain('5002').from(/graphite/).to(/udp/) }
  it { should contain('25826').from(/udp/).to(/collectd/) }
  it { should contain('127.0.0.1').from(/elasticsearch/).to(/logstash/) }
  it { should contain('9200').from(/elasticsearch/).to(/logstash/) }
end

#test db entry
describe command("sqlite3 /opt/IeAT-DICE-Repository/src/db/dmon.db 'select * from db_es_core' | grep -e 'monitor' -e '127.0.0.1' -e 'esCoreMaster' -e '9200' -e 'diceMonit' -e 'dummy' -e '1g'") do
  its(:exit_status) { should eq 0 }
end

describe command("sqlite3 /opt/IeAT-DICE-Repository/src/db/dmon.db 'select * from db_s_core' | grep -e 'monitor' -e '127.0.0.1' -e '5000' -e '25826' -e 'diceMonit' -e '512m'") do
  its(:exit_status) { should eq 0 }
end

#test if elk is running
pids = ['elasticsearch.pid', 'kibana.pid', 'logstash.pid']
pids.each do |pid|
  describe file("/opt/IeAT-DICE-Repository/src/pid/#{pid}") do
    it { should be_file }
  end
end
