#
# Cookbook Name:: zookeeper
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

zookeeper_user = node['zookeeper']['user']
zookeeper_log_dir = node['zookeeper']['log_dir']
zookeeper_conf_dir = node['zookeeper']['conf_dir']
zookeeper_data_dir = node['zookeeper']['zoo.cfg']['dataDir']

zoocfg = node['zookeeper']['zoo.cfg'].to_hash.dup

myid = nil
zookeepers = node['cloudify']['runtime_properties']['zookeeper_quorum']
zookeepers.each.with_index(1) do |zkp, i|
  zoocfg["server.#{i}"] = "#{zkp}:2888:3888"
  myid = i if zkp == node['ipaddress']
end

config = node['cloudify']['properties']['configuration']
zoocfg = zoocfg.merge(config)

template "#{zookeeper_conf_dir}/log4j.properties" do
  source 'log4j.properties.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables log_dir: zookeeper_log_dir
end

template "#{zookeeper_conf_dir}/zoo.cfg" do
  source 'zoo.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables config: zoocfg
end

template "#{zookeeper_data_dir}/myid" do
  source 'myid.erb'
  owner zookeeper_user
  group zookeeper_user
  mode '0644'
  action :create
  variables myid: myid
end
