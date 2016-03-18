#
# Cookbook Name:: spark
# Recipe:: default
#
# Copyright 2016, XLAB
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

spark_home = "#{node['spark']['prefix']}/#{node['spark']['version']}"
spark_conf = node['spark']['spark-env']['SPARK_CONF_DIR']
spark_user = node['spark']['user']
tmp_file = "#{Chef::Config[:file_cache_path]}/spark.tar.gz"

group spark_user do
  action :create
end

user spark_user do
  action :create
  gid spark_user
  shell '/bin/bash'
end

remote_file tmp_file do
  source node['spark']['tarball']
  checksum node['spark']['sha256-checksum']
  action :create
end

execute 'Extract spark' do
  command "tar -xf #{tmp_file}"
  cwd node['spark']['prefix']
  creates spark_home
end

directory spark_conf do
  action :create
  recursive true
end

[
  node['spark']['spark-env']['SPARK_WORKER_DIR'],
  node['spark']['spark-env']['SPARK_LOG_DIR']
].each do |dir|
  directory dir do
    mode 0700
    action :create
    owner spark_user
    group spark_user
    recursive true
  end
end
