#
# Cookbook:: docker
# Recipe:: configure
#
# Copyright:: 2017, XLAB d.o.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

directory '/etc/docker' do
  owner 'root'
  group 'root'
  mode '700'
end

host = "tcp://#{node['ipaddress']}:2375"

template '/etc/docker/daemon.json' do
  source 'daemon.json.erb'
  variables host: host
end

node.default['cloudify']['runtime_properties']['address'] = host
