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

version = node['cassandra']['version']
tarball = node['cassandra']['tarball']
mirror = node['cassandra']['mirror']
c_group = node['cassandra']['group']
c_user  = node['cassandra']['user']

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


local_tar = "#{Chef::Config['file_cache_path']}/#{tarball}"
local_folder = "#{Chef::Config['file_cache_path']}/apache-cassandra-#{version}"
remote_tar = "#{mirror}/#{version}/#{tarball}"

remote_file local_tar do
  source remote_tar
  checksum node['cassandra']['sha256-checksum']
  action :create
end

execute "Extract Cassandra" do
  command "tar -xf #{local_tar}"
  cwd Chef::Config['file_cache_path']
end

execute "Install Cassandra files" do
  command "mv #{local_folder} /usr/share/cassandra"
  creates '/usr/share/cassandra'
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
  variables({
    :user => c_user,
    :group => c_group,
    :version => version
  })
end
