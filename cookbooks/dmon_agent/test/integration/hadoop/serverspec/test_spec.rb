require 'serverspec'

set :backend, :exec

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
  its(:content) { should match 'crt' }
end

describe file('/etc/logstash-forwarder.conf') do
  it { should be_file }
  it { should be_owned_by 'dmon-agent' }
  its(:content_as_json) do
    should include(
      'network' => include(
        'servers' => ['10.211.55.100:5000']
      )
    )
  end
end
