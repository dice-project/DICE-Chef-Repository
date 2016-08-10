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

#test if bootstrap file was changed
describe file('/opt/IeAT-DICE-Repository/src/bootstrap.sh') do
  it { should be_file }
  it { should contain('2.2.0').from(/elasticsearch\/marvel\//).to(/# Install Logstash/) }
end

#test if python virtualenv was created
describe file('/opt/IeAT-DICE-Repository/dmonEnv') do
  it { should be_directory }
  it { should be_owned_by 'ubuntu' }
end

describe command('. /opt/IeAT-DICE-Repository/dmonEnv/bin/activate') do
  its(:exit_status) { should eq 0 }
end

#test if elk is installed
dirs = ['elasticsearch-2.2.0', 'kibana', 'logstash-2.2.1']
dirs.each do |dir|
  describe file("/opt/#{dir}") do
    it { should be_directory }
  end
end

#test logstash-forwarder crt and key
describe x509_certificate('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt') do
  it { should be_certificate }
  it { should be_valid }
  its(:subject_alt_names) { should include 'IP Address:10.211.55.100' }
end

describe x509_private_key('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.key') do
  it { should_not be_encrypted }
  it { should be_valid }
  it { should have_matching_certificate('/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt') }
end

#test if elk is running
pids = ['elasticsearch.pid', 'kibana.pid', 'logstash.pid']
pids.each do |pid|
  describe file("/opt/IeAT-DICE-Repository/src/pid/#{pid}") do
    it { should be_file }
  end
end
