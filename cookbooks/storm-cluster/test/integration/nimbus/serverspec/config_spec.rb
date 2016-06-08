require 'serverspec'

set :backend, :exec

describe 'Nimbus configuration' do
  describe file('/usr/share/storm/0.9.3/conf/storm.yaml') do
    it { should be_file }
    its(:content_as_yaml) do
      should include(
        'nimbus.host' => '123.231.45.68',
        'storm.zookeeper.servers' => ['123.231.45.66', '123.231.45.67']
      )
    end
  end
end
