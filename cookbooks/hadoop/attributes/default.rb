#
# Cookbook Name:: hadoop
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

# Package binaries
default['hadoop']['tarball'] =
  'http://www.apache.si/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz'
default['hadoop']['checksum'] =
  '8f791bfcfa5bb7c7ccd09910d490c02910dda93b19936ec2aedb8930bc5be111'

# Global settings for installation
default['hadoop']['install_dir'] = '/usr/share/hadoop'
default['hadoop']['conf_dir'] = '/etc/hadoop'
default['hadoop']['data_dir'] = '/var/lib/hadoop'
default['hadoop']['log_dir'] = '/var/log/hadoop'
default['hadoop']['pid_dir'] = '/var/run/hadoop'
default['hadoop']['group'] = 'hadoop'
default['hadoop']['hdfs_user'] = 'hdfs'
default['hadoop']['yarn_user'] = 'yarn'

# Per service settings
default['hadoop']['hdfs-site']\
       ['dfs.namenode.datanode.registration.ip-hostname-check'] = 'false'
default['hadoop']['hdfs-site']['dfs.namenode.name.dir'] =
  "file://#{node['hadoop']['data_dir']}/hdfs/namenode"
default['hadoop']['hdfs-site']['dfs.datanode.data.dir'] =
  "file://#{node['hadoop']['data_dir']}/hdfs/datanode"

default['hadoop']['yarn-site']['yarn.nodemanager.local-dirs'] =
  "file://#{node['hadoop']['data_dir']}/yarn/local"
default['hadoop']['yarn-site']['yarn.nodemanager.log-dirs'] =
  "file://#{node['hadoop']['log_dir']}/yarn/userlogs"

default['hadoop']['mapred-site']['mapreduce.framework.name'] = 'yarn'

default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.maximum-applications'] = 10_000
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.maximum-am-resource-percent'] = 0.1
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.resource-calculator'] =
  'org.apache.hadoop.yarn.util.resource.DefaultResourceCalculator'
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.queues'] = 'default'
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.default.capacity'] = 100
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.default.user-limit-factor'] = 1
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.default.maximum-capacity'] = 100
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.default.state'] = 'RUNNING'
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.default.acl_submit_applications'] = '*'
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.root.default.acl_administer_queue'] = '*'
default['hadoop']['capacity-scheduler']\
       ['yarn.scheduler.capacity.node-locality-delay'] = 40

default['hadoop']['hadoop-env']['JAVA_HOME'] = '/usr/lib/jvm/default-java'
default['hadoop']['hadoop-env']['HADOOP_CONF_DIR'] = node['hadoop']['conf_dir']
default['hadoop']['hadoop-env']['HADOOP_LOG_DIR'] =
  "#{node['hadoop']['log_dir']}/hdfs"
default['hadoop']['hadoop-env']['HADOOP_PID_DIR'] =
  "#{node['hadoop']['pid_dir']}/hdfs"
default['hadoop']['hadoop-env']['HADOOP_NAMENODE_OPTS'] =
  '-Dhadoop.security.logger=INFO,RFAS '\
  '-Dhdfs.audit.logger=INFO,NullAppender'
default['hadoop']['hadoop-env']['HADOOP_DATANODE_OPTS'] =
  '-Dhadoop.security.logger=ERROR,RFAS'
default['hadoop']['hadoop-env']['HADOOP_SECONDARYNAMENODE_OPTS'] =
  '-Dhadoop.security.logger=INFO,RFAS '\
  '-Dhdfs.audit.logger=INFO,NullAppender'
default['hadoop']['hadoop-env']['HADOOP_PORTMAP_OPTS'] = '-Xmx512m'
default['hadoop']['hadoop-env']['HADOOP_CLIENT_OPTS'] = '-Xmx512m'

default['hadoop']['yarn-env']['JAVA_HOME'] = '/usr/lib/jvm/default-java'
default['hadoop']['yarn-env']['YARN_LOG_DIR'] =
  "#{node['hadoop']['log_dir']}/yarn"
default['hadoop']['yarn-env']['YARN_PID_DIR'] =
  "#{node['hadoop']['pid_dir']}/yarn"
