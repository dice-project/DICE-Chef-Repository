#
# Cookbook Name:: kafka
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

kafka_log_dir = node['kafka']['log_dir']
kafka_conf_dir = node['kafka']['conf_dir']

config = node['kafka']['cfg'].to_hash
config.merge(node['cloudify']['properties']['configuration'].to_hash)

zookeepers = node['cloudify']['runtime_properties']['zookeeper_quorum']
config['zookeeper.connect'] = zookeepers.map { |v| "#{v}:2181" }.join(',')

template "#{kafka_conf_dir}/server.properties" do
  source 'server.properties.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables config: config
end
