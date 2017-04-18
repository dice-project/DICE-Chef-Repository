#
# Cookbook Name:: mongodb
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

# Ubuntu repo data
default['mongodb']['apt']['uri'] = 'http://repo.mongodb.org/apt/ubuntu'
default['mongodb']['apt']['dist'] = 'mongodb-org/3.4'
default['mongodb']['apt']['keyserver'] = 'keyserver.ubuntu.com'
default['mongodb']['apt']['key'] = '0C49F3730359A14518585931BC711F9BA15703C6'
default['mongodb']['apt']['arch'] = 'amd64'
default['mongodb']['apt']['components'] = ['multiverse']

# Service info
default['mongodb']['service'] = 'mongod' # Can also be mongos for router

default['mongodb']['local_admin'] = 'node_admin'

# Orchestrator provided data
# node['cloudify']['properties']['type'] can be
#   - standalone, in which case this node is not part of any replica/shard,
#   - replica, in which case this node is part of the replica,
#   - shard, in which case this node is part of the shard,
#   - config, in which case this node is part of the configuration replica.
#   - unset, which behaves as standalone.
#
# node['cloudify']['properties']['bind_ip'] can be
#   - local, in which case we bind to internal IP address,
#   - global, in which case we bind to 0.0.0.0,
#   - unset, which behaves like local.
