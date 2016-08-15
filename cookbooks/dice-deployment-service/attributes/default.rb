#
# Cookbook Name:: dice-deployment-service
# Attribute:: default
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
#

default['dice-deployment-service']['app_user'] = 'dice'
default['dice-deployment-service']['app_prefix'] =
  '/var/lib/dice-deployment-service'
default['dice-deployment-service']['app_folder'] =
  "#{node['dice-deployment-service']['app_prefix']}/dds"
default['dice-deployment-service']['app_socket'] =
  "#{node['dice-deployment-service']['app_prefix']}/dds.socket"
default['dice-deployment-service']['app_venv'] =
  "#{node['dice-deployment-service']['app_prefix']}/venv"

# Cloudify provided attributes (do not uncomment this, this is here for
# documentation purpose only):
#
# Additional ssh key that should be added to deployment service user
# default['cloudify']['properties']['ssh_key'] = ''
#
# Install service in debug mode
# default['cloudify']['properties']['debug_mode'] = true
#
# Source tarball for service files
# default['cloudify']['properties']['sources'] =
#   'https://github.com/dice-project/DICE-Deployment-Service/archive/develop.tar.gz'
#
# Information about Cloudify manager that will do actual deployments
# default['cloudify']['properties']['manager'] = '1.2.3.4'
# default['cloudify']['properties']['manager_user'] = 'username'
# default['cloudify']['properties']['manager_pass'] = 'password'
#
# Information about admin credentials that should be created during install
# default['cloudify']['properties']['superuser_username'] = 'username'
# default['cloudify']['properties']['superuser_password'] = 'password'
# default['cloudify']['properties']['superuser_email'] = 'email@xlab.si'
