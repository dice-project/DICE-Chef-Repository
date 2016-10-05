#
# Cookbook Name:: kafka
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

kafka_user = node['kafka']['user']
kafka_log_dir = node['kafka']['log_dir']
kafka_conf_dir = node['kafka']['conf_dir']
kafka_install_dir = node['kafka']['install_dir']

kafka_dirs = node['kafka']['cfg']['log.dirs'].split(',')
kafka_dirs << kafka_log_dir

group kafka_user do
  action :create
end

user kafka_user do
  gid kafka_user
  home "/home/#{kafka_user}"
  shell '/bin/bash'
  action :create
end

kafka_tar = "#{Chef::Config[:file_cache_path]}/kafka.tar.gz"
remote_file kafka_tar do
  source node['kafka']['tarball']
  checksum node['kafka']['checksum']
  action :create
end

poise_archive kafka_tar do
  destination kafka_install_dir
end

directory kafka_conf_dir do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

kafka_dirs.each do |folder|
  directory folder do
    mode '0700'
    owner kafka_user
    group kafka_user
    action :create
    recursive true
  end
end

template '/etc/init/kafka.conf' do
  source 'kafka.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables(
    kafka_user: kafka_user,
    kafka_home: kafka_install_dir,
    kafka_log_dir: kafka_log_dir,
    kafka_config: "#{kafka_conf_dir}/server.properties"
  )
end
