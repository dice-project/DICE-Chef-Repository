#
# Cookbook Name:: storm
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

storm_user = node['storm']['user']
storm_install_dir = node['storm']['install_dir']

group storm_user do
  action :create
end

user storm_user do
  comment 'For storm services'
  gid storm_user
  home "/home/#{storm_user}"
  shell '/bin/bash'
  action :create
end

storm_tar = "#{Chef::Config[:file_cache_path]}/storm.tar.gz"
remote_file storm_tar do
  source node['storm']['tarball']
  checksum node['storm']['checksum']
  action :create
end

poise_archive storm_tar do
  destination storm_install_dir
end

script 'Update permissions and install binary link' do
  interpreter 'bash'
  user 'root'
  code <<-EOL
    chown -R #{storm_user}:#{storm_user} #{storm_install_dir}
    ln -fs #{storm_install_dir}/bin/storm /usr/local/bin/storm
  EOL
end

# Service files
template '/etc/init/storm-supervisor.conf' do
  source 'storm-daemon.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables service: 'supervisor'
end

template '/etc/init/storm-nimbus.conf' do
  source 'storm-daemon.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables service: 'nimbus'
end

template '/etc/init/storm-ui.conf' do
  source 'storm-daemon.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables service: 'ui'
end
