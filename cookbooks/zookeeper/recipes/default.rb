#
# Cookbook Name:: zookeeper
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

zookeeper_user = node['zookeeper']['user']
zookeeper_log_dir = node['zookeeper']['log_dir']
zookeeper_conf_dir = node['zookeeper']['conf_dir']
zookeeper_data_dir = node['zookeeper']['zoo.cfg']['dataDir']
zookeeper_install_dir = node['zookeeper']['install_dir']

group zookeeper_user do
  action :create
end

user zookeeper_user do
  gid zookeeper_user
  home "/home/#{zookeeper_user}"
  shell '/bin/bash'
  action :create
end

zookeeper_tar = "#{Chef::Config[:file_cache_path]}/zookeeper.tar.gz"
remote_file zookeeper_tar do
  source node['zookeeper']['tarball']
  checksum node['zookeeper']['checksum']
  action :create
end

poise_archive zookeeper_tar do
  destination zookeeper_install_dir
end

directory zookeeper_conf_dir do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

[zookeeper_data_dir, zookeeper_log_dir].each do |folder|
  directory folder do
    mode '0700'
    owner zookeeper_user
    group zookeeper_user
    action :create
    recursive true
  end
end

template '/etc/init/zookeeper.conf' do
  source 'zookeeper.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables(
    zookeeper_user: zookeeper_user,
    zookeeper_home: zookeeper_install_dir,
    zookeeper_conf_dir: zookeeper_conf_dir,
    zookeeper_log_dir: zookeeper_log_dir
  )
end
