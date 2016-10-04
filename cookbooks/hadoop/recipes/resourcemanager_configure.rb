#
# Cookbook Name:: hadoop
# Recipe:: resourcemanager_configure
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

install_dir = node['hadoop']['install_dir']
conf_dir = node['hadoop']['conf_dir']
hadoop_group = node['hadoop']['group']
yarn_user = node['hadoop']['yarn_user']

execute 'format state store' do
  environment 'PATH' => "#{install_dir}/bin:#{ENV['PATH']}"
  command "yarn --config #{conf_dir} resourcemanager -format-state-store"
  group hadoop_group
  user yarn_user
end
