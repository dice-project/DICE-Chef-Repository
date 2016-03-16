#
# Cookbook Name:: hadoop-upstream
# Recipe:: datanode-install
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

# Run commmon stuff
include_recipe "hadoop-upstream::default"
hadoop_home = "#{node["prefix"]}/#{node["hadoop-version"]}"

user "hdfs" do
  home "/home/hdfs"
  shell "/bin/bash"
end

data_dirs = node["hdfs-site"]["dfs.datanode.data.dir"].split(",")
data_dirs_local = data_dirs.map {|v| v.gsub("file://", "")}

data_dirs_local.each do |folder|
  directory folder do
    mode "0700"
    owner "hdfs"
    group "hdfs"
    action :create
    recursive true
  end
end

directory "#{node["hadoop-env"]["HADOOP_LOG_DIR"]}" do
  mode "0755"
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
end

template "/etc/init/datanode.conf" do
  source "init.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  action :create
  variables :opts => {
    "description" => "Hadoop HDFS datanode",
    "runner" => "#{hadoop_home}/sbin/hadoop-daemon.sh",
    "config" => "#{node["conf-dir"]}",
    "service" => "datanode",
    "user" => "hdfs"
  }
end
