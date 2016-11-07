# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2016, XLAB d.o.o.
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

# This recipe will install cassandra data files and init scripts.

c_group = node['cassandra']['group']
c_user  = node['cassandra']['user']
install_dir = node['cassandra']['install_dir']

group c_group do
  action :create
end

user c_user do
  gid c_group
  shell '/bin/bash'
  action :create
end

directory "/home/#{c_user}" do
  mode 0700
  user c_user
  group c_group
  action :create
end

cassandra_tar = "#{Chef::Config[:file_cache_path]}/cassandra.tar.gz"
remote_file cassandra_tar do
  source node['cassandra']['tarball']
  checksum node['cassandra']['checksum']
  action :create
end

poise_archive cassandra_tar do
  destination install_dir
end

dirs = ['/var/log/cassandra', '/var/lib/cassandra']
dirs.each do |dir|
  directory dir do
    mode 0700
    action :create
    owner c_user
    group c_group
    recursive true
  end
end

directory '/etc/cassandra' do
  mode 0755
  action :create
end

template '/etc/init/cassandra.conf' do
  source 'cassandra.conf.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables user: c_user, group: c_group
end
