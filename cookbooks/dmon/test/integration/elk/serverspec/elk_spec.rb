require 'serverspec'

set :backend, :exec

describe group('ubuntu') do
  it { should exist }
end

describe user('ubuntu') do
  it { should exist }
  it { should belong_to_group 'ubuntu' }
  it { should have_login_shell '/bin/bash' }
end

describe file('/opt/IeAT-DICE-Repository') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe file('/opt/IeAT-DICE-Repository/src/logs/dmon-controller.log') do
  it { should be_file }
  it { should be_owned_by 'ubuntu' }
end

describe file('/opt/IeAT-DICE-Repository/dmonEnv') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe command('. /opt/IeAT-DICE-Repository/dmonEnv/bin/activate') do
  its(:exit_status) { should eq 0 }
end

describe file('/etc/init/dmon.conf') do
  it { should be_file }
  it { should contain('root').from(/setuid/).to(/setgid/) }
  it { should contain('root').from(/setgid/).to(/script/) }
  it { should contain('5001').from(/script/).to(/end/) }
end

describe service('dmon') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/opt/elasticsearch') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe file('/opt/elasticsearch/config/elasticsearch.yml') do
  it { should be_file }
  it { should contain('diceMonit').from(/cluster.name:/).to(/#/) }
  it { should contain('esCoreMaster').from(/node.name:/).to(/#/) }
  it do
    should contain('/opt/IeAT-DICE-Repository/src/logs')
      .from(/path.logs:/).to(/#/)
  end
end

describe file('/opt/kibana') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe file('/opt/kibana/config/kibana.yml') do
  it { should be_file }
  it { should contain('5601').from(/server.port:/).to(/#/) }
  it { should contain('127.0.0.1').from(/elasticsearch.url:/).to(/#/) }
  it { should contain('9200').from(/elasticsearch.url:/).to(/#/) }
  it do
    should contain('/opt/IeAT-DICE-Repository/src/pid/kibana.pid')
      .from(/pid.file:/).to(/#/)
  end
  it do
    should contain('/opt/IeAT-DICE-Repository/src/logs/kibana.log')
      .from(/logging.dest:/).to(/#/)
  end
end

describe file('/opt/logstash') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe file('/opt/IeAT-DICE-Repository/src/logs/logstash.log') do
  it { should be_file }
  it { should be_owned_by 'ubuntu' }
end

private_key = '/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.key'
certificate = '/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt'

describe x509_certificate(certificate) do
  it { should be_certificate }
  it { should be_valid }
end

describe x509_private_key(private_key) do
  it { should_not be_encrypted }
  it { should be_valid }
  it { should have_matching_certificate(certificate) }
end
