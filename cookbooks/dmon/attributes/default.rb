# Cookbook Name:: dmon
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

# General attributes
# DO NOT CHANGE THESE - bootstrap will fail spectacularly
default['dmon']['group'] = 'ubuntu'
default['dmon']['user'] = 'ubuntu'
# END OF DO NOT CHANGE BLOCK

default['dmon']['tarball'] =
  'http://github.com/dice-project/DICE-Monitoring/archive/'\
  '483147e4398d955ee2497ea6f3601065b7abbbd0.tar.gz'
default['dmon']['checksum'] =
  'd2bbca8dd2257949cf9f924b158484e8aafa0bd82c70ba6e162a37be3b908fcd'

default['dmon']['install_dir'] = '/opt/DICE-Monitoring'

default['dmon']['port'] = '5001'

# Elasticsearch configuration attributes
default['dmon']['es']['source'] =
  'https://download.elasticsearch.org/elasticsearch/release/org/'\
  'elasticsearch/distribution/tar/elasticsearch/2.2.0/'\
  'elasticsearch-2.2.0.tar.gz'
default['dmon']['es']['checksum'] =
  'ed70cc81e1f55cd5f0032beea2907227b6ad8e7457dcb75ddc97a2cc6e054d30'
default['dmon']['es']['install_dir'] = '/opt/elasticsearch'
default['dmon']['es']['cluster_name'] = 'diceMonit'
default['dmon']['es']['heap_size'] =
  "#{node['memory']['total'][/\d*/].to_i / 2_000_000}g"
default['dmon']['es']['ip'] = '127.0.0.1'
default['dmon']['es']['node_name'] = 'esCoreMaster'
default['dmon']['es']['port'] = 9200

# Kibana configuration attributes
default['dmon']['kb']['source'] =
  'https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz'
default['dmon']['kb']['checksum'] =
  'fb536696b27b9807507c5d9014c90722e7b28cb2e068a80879cc9bb861316be1'
default['dmon']['kb']['install_dir'] = '/opt/kibana'
default['dmon']['kb']['port'] = 5601

# Logstash configuration attributes
default['dmon']['ls']['source'] =
  'https://download.elastic.co/logstash/logstash/logstash-2.2.1.tar.gz'
default['dmon']['ls']['checksum'] =
  'a7c55428aabdf2a2143f5907f3e5bb4bfba897f17359142e4dae70d7b446591e'
default['dmon']['ls']['install_dir'] = '/opt/logstash'
default['dmon']['ls']['heap_size'] = '1g'
default['dmon']['ls']['core_workers'] = 2