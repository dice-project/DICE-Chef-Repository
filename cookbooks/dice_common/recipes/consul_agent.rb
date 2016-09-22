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

template '/etc/init/consul-agent.conf' do
  source 'consul-agent.conf.erb'
  variables(
    master: node['cloudify']['properties']['master_ip'],
    data: '/var/lib/consul'
  )
end

service 'consul-agent' do
  supports status: true, restart: true
  provider Chef::Provider::Service::Upstart if node['platform'] == 'ubuntu'
  action :start
end
