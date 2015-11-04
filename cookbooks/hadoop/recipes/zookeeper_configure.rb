#
# Cookbook Name:: hadoop
# Recipe:: zookeeper_configure
#
# Copyright © 2015 XLAB d.o.o.
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

zookeepers_hash = 
	node["cloudify"]["runtime_properties"]["zookeeper_servers"]
zookeepers = zookeepers_hash.values.map { |ipaddress| ipaddress }

zookeeper_conf_dir = "/etc/zookeeper/#{node['zookeeper']['conf_dir']}"

if node['zookeeper'].key?('zoocfg') && !node['zookeeper']['zoocfg'].empty?
	zoocfg = node['zookeeper']['zoocfg'].to_hash.dup
	zookeepers.each_with_index do |zkp, i| 
		zoocfg["server.#{i}"] = "#{zkp}:#{node['zookeeper']['peer_port']}"
	end

	# Setup zoo.cfg
	template "#{zookeeper_conf_dir}/zoo.cfg" do
	  source 'generic.properties.erb'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
	  variables :properties => zoocfg
	end # End zoo.cfg
end
