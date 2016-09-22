#
# Cookbook Name:: storm
# Recipe:: configure
#
# Copyright 2016, XLAB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

storm_user = node['storm']['user']
storm_install_dir = node['storm']['install_dir']

rt_props = node['cloudify']['runtime_properties'].to_hash
storm_yaml = node['cloudify']['properties']['configuration'].to_hash.dup
storm_yaml['storm.zookeeper.servers'] = rt_props['zookeeper_quorum']
storm_yaml['nimbus.seeds'] = if rt_props.key?('storm_nimbus_ip')
                               [rt_props['storm_nimbus_ip']]
                             else
                               [node['ipaddress']]
                             end

template "#{storm_install_dir}/conf/storm.yaml" do
  source 'storm.yaml.erb'
  mode '0644'
  owner storm_user
  group storm_user
  variables storm_yaml: storm_yaml
end
