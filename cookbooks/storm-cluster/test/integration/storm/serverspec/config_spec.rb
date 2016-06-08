require 'serverspec'

set :backend, :exec

describe 'Storm configuration' do
  describe file('/usr/share/storm/0.9.3/conf/storm.yaml') do
    it { should be_file }
    its(:content_as_yaml) do
      should include(
        'nimbus.host' => '543.210.65.43',
        'storm.zookeeper.servers' => ['a.b.c.d', 'e.f.g.h']
      )
    end
  end
end
