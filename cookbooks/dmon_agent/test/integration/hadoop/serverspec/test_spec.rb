require 'serverspec'

set :backend, :exec

describe package('logstash-forwarder') do
  it { should be_installed }
end

describe file('/etc/ssl/certs/logstash-forwarder.crt') do
  it { should be_file }
  its(:content) { should match 'crt' }
end

describe file('/etc/logstash-forwarder.conf.d/net.conf') do
  it { should be_file }
  its(:content_as_json) do
    should include(
      'network' => include(
        'servers' => ['10.211.55.100:5000']
      )
    )
  end
end
