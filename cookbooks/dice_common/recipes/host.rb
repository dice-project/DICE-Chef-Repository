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

# hostname format:
#  * deployment marker (6 characters)
#  * node id (max 40 characters)
#  * MAC address (12 characters)
deploy_abbrev = node['cloudify']['deployment_id'][0, 6]
node_name = node['cloudify']['node_id'].sub(/_[^_]*$/, '')
node_name_dash = node_name.tr('_', '-')[0, 40]
mac_concat = node['macaddress'].delete ':'

hostname = "#{deploy_abbrev}-#{node_name_dash}-#{mac_concat}"
fqdn = "#{hostname}.node.consul"

node.default['cloudify']['runtime_properties']['ip'] = node['ipaddress']
node.default['cloudify']['runtime_properties']['fqdn'] = fqdn

ohai 'reload' do
  plugin 'hostname'
  action :nothing
end

template '/etc/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables ip: node['ipaddress'], fqdn: fqdn, hostname: hostname
  notifies :reload, 'ohai[reload]', :immediately
end

case node['platform_family']
when 'rhel'
  service 'network' do
    action :nothing
  end

  hostfile = '/etc/sysconfig/network'
  file hostfile do
    action :create
    content lazy {
      ::IO.read(hostfile).gsub(/^HOSTNAME=.*$/, "HOSTNAME=#{fqdn}")
    }
    notifies :reload, 'ohai[reload]', :immediately
    notifies :restart, 'service[network]', :delayed
  end

  sysctl = '/etc/sysctl.conf'
  file sysctl do
    action :create
    content lazy {
      ::IO.read(sysctl) + "kernel.hostname=#{hostname}\n"
    }
    not_if { ::IO.read(sysctl) =~ /^kernel\.hostname=#{hostname}$/ }
    notifies :reload, 'ohai[reload]', :immediately
    notifies :restart, 'service[network]', :delayed
  end
else
  file '/etc/hostname' do
    content "#{hostname}\n"
    mode '0644'
    notifies :reload, 'ohai[reload]', :immediately
  end
end

execute "hostname #{hostname}" do
  notifies :reload, 'ohai[reload]', :immediately
end
