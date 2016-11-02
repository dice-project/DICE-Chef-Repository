#
# Cookbook Name:: dice_common
# Recipe:: default
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

fqdn = "#{node['hostname']}.node.consul"

node.default['cloudify']['runtime_properties']['ip'] = node['ipaddress']
node.default['cloudify']['runtime_properties']['fqdn'] = fqdn

ohai 'reload' do
  action :nothing
end

template '/etc/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables ip: node['ipaddress'], fqdn: fqdn, hostname: node['hostname']
  notifies :reload, 'ohai[reload]', :immediately
end
