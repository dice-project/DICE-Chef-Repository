#
# Cookbook Name:: mongodb
# Recipe:: start
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

require 'securerandom'

service node['mongodb']['service'] do
  action [:enable, :restart]
end

admin_user = node['mongodb']['local_admin']
admin_pass = SecureRandom.base64 30
admin_script = "#{Chef::Config[:file_cache_path]}/add_admin.js"
template admin_script do
  source 'add_admin_user.js.erb'
  variables admin_pass: admin_pass, admin_user: admin_user
end

bash 'Create mongo admin' do
  code "mongo --host 127.0.0.1:27017 #{admin_script}"
  retries 10
end

node.default['cloudify']['runtime_properties']['admin_user'] = admin_user
node.default['cloudify']['runtime_properties']['admin_pass'] = admin_pass

file admin_script do
  action :delete
end
