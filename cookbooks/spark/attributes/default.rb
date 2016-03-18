#
# Cookbook Name:: spark
# Attribute:: default
#
# Copyright 2016, XLAB
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Package binaries
default['spark']['version'] = 'spark-2.0.0-bin-hadoop2.7'
default['spark']['sha256-checksum'] =
  '3d46e990c06a362efc23683cf0ec15e1943c28e023e5b5d4e867c78591c937ad'
default['spark']['tarball'] =
  'http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz'

# Global settings for installation
default['spark']['prefix'] = '/usr/share'
default['spark']['user'] = 'spark'

# Should node be prepared as master or worker?
default['spark']['type'] = 'worker' # Set to 'master' for master

# Spark configuration - common
default['spark']['spark-env']['SPARK_CONF_DIR'] = '/etc/spark'
default['spark']['spark-env']['SPARK_LOG_DIR'] = '/var/log/spark'
default['spark']['spark-env']['SPARK_IDENT_STRING'] = 'default_ident'

# YARN integration
# default['spark']['spark-env']['HADOOP_CONF_DIR'] = '/etc/hadoop'

# Standalone mode
default['spark']['spark-env']['SPARK_MASTER_PORT'] = '7077'
default['spark']['spark-env']['SPARK_WORKER_PORT'] = '7078'
default['spark']['spark-env']['SPARK_WORKER_DIR'] = '/var/lib/spark/'

# Configuration that is supplied by Cloudify
# default['spark']['spark-env']['SPARK_LOCAL_IP']
# default['spark']['spark-env']['SPARK_MASTER_HOST']

# TODO: Next setting should be autoconfigured by means of hadoop classpath
# retrieval
# default['spark']['spark-env']['SPARK_DIST_CLASSPATH'] =
#   '/etc/hadoop:'\
#   '/opt/hadoop-2.7.2/share/hadoop/common/lib/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/common/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/hdfs:'\
#   '/opt/hadoop-2.7.2/share/hadoop/hdfs/lib/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/hdfs/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/yarn/lib/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/yarn/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/mapreduce/lib/*:'\
#   '/opt/hadoop-2.7.2/share/hadoop/mapreduce/*'
