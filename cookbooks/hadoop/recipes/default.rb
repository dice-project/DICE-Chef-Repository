#
# Cookbook Name:: hadoop
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

install_dir = node['hadoop']['install_dir']
conf_dir = node['hadoop']['conf_dir']
hadoop_group = node['hadoop']['group']
hdfs_user = node['hadoop']['hdfs_user']
yarn_user = node['hadoop']['yarn_user']

group hadoop_group do
  action :create
end

[hdfs_user, yarn_user].each do |name|
  user name do
    gid hadoop_group
    home "/home/#{name}"
    shell '/bin/bash'
    action :create
  end
end

hadoop_tar = "#{Chef::Config[:file_cache_path]}/hadoop.tar.gz"
remote_file hadoop_tar do
  source node['hadoop']['tarball']
  checksum node['hadoop']['checksum']
  action :create
end

poise_archive hadoop_tar do
  destination install_dir
end

directory conf_dir do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

[
  %w(namenode hdfs hdfs), %w(datanode hdfs hdfs),
  %w(resourcemanager yarn yarn), %w(nodemanager yarn yarn)
].each do |service, command, service_user|
  template "/etc/init/#{service}.conf" do
    source 'init.conf.erb'
    mode '0644'
    owner 'root'
    group 'root'
    action :create
    variables(
      description: "Hadoop #{service} service",
      user: service_user,
      group: hadoop_group,
      cmd: "#{install_dir}/bin/#{command}",
      service: service,
      conf_dir: conf_dir
    )
  end
end

# Install some wrappers to make running Hadoop commands easier
%w(hadoop hdfs yarn).each do |command|
  template "/usr/bin/#{command}" do
    source 'command.erb'
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    variables(
      command: command, install_dir: install_dir, conf_dir: conf_dir
    )
  end
end
