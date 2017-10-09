#
# Cookbook Name:: docker
# Attribute:: default
#
# Copyright 2017 XLAB d.o.o.
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

default['docker']['apt']['uri'] = 'https://download.docker.com/linux/ubuntu'
default['docker']['apt']['key'] =
  'https://download.docker.com/linux/ubuntu/gpg'
default['docker']['apt']['arch'] = 'amd64'
default['docker']['apt']['components'] = ['stable']
default['docker']['apt']['version'] = '17.09.0~ce-0~ubuntu'
