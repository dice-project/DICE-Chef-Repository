#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2017 XLAB d.o.o.
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

apt_repository 'mongodb34' do
  uri node['mongodb']['apt']['uri']
  distribution "#{node['lsb']['codename']}/#{node['mongodb']['apt']['dist']}"
  keyserver node['mongodb']['apt']['keyserver']
  key node['mongodb']['apt']['key']
  arch node['mongodb']['apt']['arch']
  components node['mongodb']['apt']['components']
end

package 'mongodb-org'

service 'mongod' do
  action [:disable, :stop]
end

service_template 'mongos'

service 'mongos' do
  action [:disable, :stop]
end
