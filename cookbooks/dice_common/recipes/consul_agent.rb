#
# Cookbook Name:: dice_common
# Recipe:: consul_agent
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

is_ubuntu_1404 = platform?('ubuntu') && node['platform_version'] == '14.04'
if is_ubuntu_1404
  service_file = '/etc/init/consul-agent.conf'
  service_template = 'consul-agent.conf.erb'
else
  service_file = '/etc/systemd/system/consul-agent.service'
  service_template = 'consul-agent.service.erb'
end

template service_file do
  source service_template
  variables(
    master: node['cloudify']['properties']['dns_server'],
    bind: node['ipaddress'],
    data: '/var/lib/consul'
  )
end

service 'consul-agent' do
  action [:enable, :start]
end
