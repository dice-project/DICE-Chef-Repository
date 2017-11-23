#
# Cookbook Name:: kafka
# Attribute:: default
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

# General settings
default['kafka']['install_dir'] = '/usr/share/kafka'
default['kafka']['port'] = 9092
default['kafka']['conf_dir'] = '/etc/kafka'
default['kafka']['log_dir'] = '/var/log/kafka'
default['kafka']['user'] = 'kafka'
default['kafka']['tarball'] =
  'http://www.apache.si/kafka/1.0.0/kafka_2.11-1.0.0.tgz'
default['kafka']['checksum'] =
  'b5b535f8db770cda8513e391917d0f5a35ef24c537ef3d29dcd9aa287da529f5'

# Kafka configuration
default['kafka']['cfg']['log.dirs'] = '/var/lib/kafka'
default['kafka']['cfg']['listeners'] = "PLAINTEXT://:#{node['kafka']['port']}"
