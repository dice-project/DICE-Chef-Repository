require 'spec_helper'

describe 'Storm configuration' do
  describe file('/usr/share/storm/conf/storm.yaml') do
    it { should be_file }
    its(:content_as_yaml) do
      should include(
        'nimbus.seeds' => ['123.231.45.68'],
        'storm.zookeeper.servers' => ['123.231.45.66', '123.231.45.67'],
        'test_config_1' => 'value_1',
        'test_config_2' => 'value_2'
      )
    end
  end
end
