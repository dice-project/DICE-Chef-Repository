#
# Cookbook:: docker
# Recipe:: default
#
# Copyright:: 2017, XLAB d.o.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package %w(apt-transport-https ca-certificates software-properties-common) do
  only_if { node['lsb']['codename'] == 'trusty' }
end

apt_repository 'docker-ce' do
  uri node['docker']['apt']['uri']
  distribution node['lsb']['codename']
  key node['docker']['apt']['key']
  arch node['docker']['apt']['arch']
  components node['docker']['apt']['components']
end

package 'docker-ce' do
  version node['docker']['apt']['version']
end

# Ugly hack for Ubuntu 16.04 docker service. By default, service does not
# allow us to override hosts setting, because it is hardcoded in the service
# file. This hack replaces official service file with the one that comes with
# Fedora packages and has no hardcoded hosts.
#
# Just for reference, this is the error that we get in system logs:
#   unable to configure the Docker daemon with file /etc/docker/daemon.json:
#   the following directives are specified both as a flag and in the
#   configuration file:
#   hosts: (from flag: [fd://], from file: [tcp://10.0.2.15:2375 ...
cookbook_file '/lib/systemd/system/docker.service' do
  source 'docker.service'
  owner 'root'
  group 'root'
  mode '0644'
  only_if { node['lsb']['codename'] == 'xenial' }
  notifies :run, 'execute[Reload systemd daemon]', :immediately
end

execute 'Reload systemd daemon' do
  command 'systemctl daemon-reload'
  action :nothing
end
