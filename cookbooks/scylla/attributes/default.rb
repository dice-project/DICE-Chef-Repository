# Cookbook Name:: scylla
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

# CentOS repos
centos_repo_url = 'https://s3.amazonaws.com/downloads.scylladb.com/rpm'
default['scylla']['centos']['repos'] = [{
  id: 'scylla',
  desc: 'Scylla for Centos $releasever - $basearch',
  url: "#{centos_repo_url}/centos/scylladb-1.4/$releasever/$basearch/"
}, {
  id: 'scylla-generic',
  desc: 'Scylla for Centos $releasever',
  url: "#{centos_repo_url}/centos/scylladb-1.4/$releasever/noarch/"
}, {
  id: 'scylla-3rdparty',
  desc: 'Scylla 3rdParty for Centos $releasever - $basearch',
  url: "#{centos_repo_url}/3rdparty/centos/scylladb-1.4/$releasever/$basearch/"
}, {
  id: 'scylla-3rdparty-generic',
  desc: 'Scylla 3rdParty for Centos $releasever',
  url: "#{centos_repo_url}/3rdparty/centos/scylladb-1.4/$releasever/noarch/"
}]

# Ubuntu repos
ubuntu_repo_url = 'http://s3.amazonaws.com/downloads.scylladb.com/deb/ubuntu'
default['scylla']['ubuntu']['repos'] = [{
  id: 'scylla',
  uri: ubuntu_repo_url,
  arch: 'amd64',
  components: ['scylladb-1.4/multiverse']
}]

# Configuration - folders
default['scylla']['yaml']['data_file_directories'] = [
  '/var/lib/scylla/data'
]
default['scylla']['yaml']['saved_caches_directory'] =
  '/var/lib/scylla/saved_caches'
default['scylla']['yaml']['commitlog_directory'] =
  '/var/lib/scylla/commitlog'
default['scylla']['yaml']['hints_directory'] =
  '/var/lib/scylla/hints'

# Default configuration
default['scylla']['yaml']['cluster_name'] = 'Sample Cluster'
default['scylla']['yaml']['num_tokens'] = 256
default['scylla']['yaml']['commitlog_sync'] = 'periodic'
default['scylla']['yaml']['commitlog_sync_period_in_ms'] = 10_000
default['scylla']['yaml']['partitioner'] =
  'org.apache.cassandra.dht.Murmur3Partitioner'
default['scylla']['yaml']['endpoint_snitch'] = 'GossipingPropertyFileSnitch'
default['scylla']['yaml']['auto_bootstrap'] = false
default['scylla']['yaml']['start_native_transport'] = true
default['scylla']['yaml']['native_transport_port'] = 9042
default['scylla']['yaml']['api_port'] = 10_000

# Settings that should be set by cloudify (present here only for documentation
# purposes)

# default['scylla']['yaml']['api_address'] = 'IP address of the machine'
# default['scylla']['yaml']['listen_address'] = 'IP address of the machine'
# default['scylla']['yaml']['rpc_address'] = 'IP address of the machine'
# default['scylla']['yaml']['seed_provider'] = [{
#   'class_name': 'org.apache.cassandra.locator.SimpleSeedProvider',
#   'parameters': [{
#     'seeds': '172.16.0.11,172.16.0.12'
#   }]
# }]
