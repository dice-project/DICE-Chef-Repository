# Cookbook Name:: dmon
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

install_dir = node['dmon']['install_dir']
dmon_user = node['dmon']['user']
dmon_group = node['dmon']['group']

group dmon_group

user dmon_user do
  group dmon_group
  system true
  shell '/bin/bash'
end

dmon_tar = "#{Chef::Config[:file_cache_path]}/dmon.tar.gz"
remote_file dmon_tar do
  source node['dmon']['tarball']
  checksum node['dmon']['checksum']
  action :create
end

poise_archive dmon_tar do
  destination install_dir
end

directory "#{node['dmon']['install_dir']}/src/pid" do
  owner dmon_user
  group dmon_group
  recursive true
  action :create
end

directory "#{node['dmon']['install_dir']}/src/logs" do
  owner dmon_user
  group dmon_group
  recursive true
  action :create
end

execute 'Setting dmon permissions' do
  command "chown -R #{dmon_user}:#{dmon_group} #{install_dir}"
end

# Create empty dmon-controller log file
file "#{install_dir}/src/logs/dmon-controller.log" do
  content ''
  owner dmon_user
  group dmon_group
  not_if { File.exist?("#{install_dir}/src/logs/dmon-controller.log") }
end

python_runtime 'dmonPy' do
  version '2.7'
end

python_virtualenv 'dmonEnv' do
  path "#{install_dir}/dmonEnv"
  python 'dmonPy'
  user dmon_user
  group dmon_group
end

pip_requirements 'dmonPip' do
  path "#{install_dir}/src/requirements.txt"
  virtualenv 'dmonEnv'
  user dmon_user
  group dmon_group
end

directory '/opt/DmonBackup' do
  action :create
end

template '/etc/init/dmon.conf' do
  source 'dmon.conf.erb'
end

service 'dmon' do
  action [:enable, :start]
end
