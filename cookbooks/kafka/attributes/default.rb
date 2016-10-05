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
  'http://www.apache.si/kafka/0.10.0.1/kafka_2.11-0.10.0.1.tgz'
default['kafka']['checksum'] =
  '2d73625aeddd827c9e92eefb3c727a78455725fbca4361c221eaa05ae1fab02d'

# Kafka configuration
default['kafka']['cfg']['log.dirs'] = '/var/lib/kafka'
default['kafka']['cfg']['listeners'] = "PLAINTEXT://:#{node['kafka']['port']}"
