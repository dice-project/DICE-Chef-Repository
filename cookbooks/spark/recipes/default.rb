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

install_dir = node['spark']['install_dir']
conf_dir = node['spark']['spark-env']['SPARK_CONF_DIR']
spark_user = node['spark']['user']
version = node['spark']['version']

group spark_user do
  action :create
end

user spark_user do
  action :create
  gid spark_user
  shell '/bin/bash'
end

spark_tar = "#{Chef::Config[:file_cache_path]}/spark-#{version}.tar.gz"
remote_file spark_tar do
  source node['spark'][version]['tarball']
  checksum node['spark'][version]['checksum']
  action :create
end

poise_archive spark_tar do
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

# Wrappers for commands
suffixes = ["-#{version}"]
suffixes << '' if node['spark']['alias']

%w(pyspark spark-class sparkR spark-shell spark-sql spark-submit).each do |cmd|
  suffixes.each do |suffix|
    template "/usr/bin/#{cmd}#{suffix}" do
      source 'command.erb'
      mode '0755'
      owner 'root'
      group 'root'
      action :create
      variables(
        command: cmd, install_dir: install_dir, conf_dir: conf_dir
      )
    end
  end
end
