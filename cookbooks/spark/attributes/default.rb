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

# General settings
default['spark']['version'] = '2.0' # Also available: '1.6'
default['spark']['alias'] = true # Create non-suffixed commands too

default['spark']['1.6']['checksum'] =
  'bddeccec0fb8ac9491cbb4e320467e9263bcc1caf9b45466164f8ae2d97de710'
default['spark']['1.6']['tarball'] =
  'http://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz'

default['spark']['2.0']['checksum'] =
  '3d017807650f41377118a736e2f2298cd0146a593e7243a28c2ed72a88b9a043'
default['spark']['2.0']['tarball'] =
  'http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz'

# Global settings for installation
default['spark']['install_dir'] =
  "/usr/share/spark-#{node['spark']['version']}"
default['spark']['user'] = 'spark'

# Should node be prepared as master or worker?
default['spark']['type'] = 'worker' # Set to 'master' for master

# Spark configuration - common
default['spark']['spark-env']['SPARK_CONF_DIR'] =
  "/etc/spark-#{node['spark']['version']}"
default['spark']['spark-env']['SPARK_LOG_DIR'] =
  "/var/log/spark-#{node['spark']['version']}"
default['spark']['spark-env']['SPARK_IDENT_STRING'] = node['hostname']

# YARN integration
default['spark']['spark-env']['HADOOP_CONF_DIR'] = '/etc/hadoop'

# Standalone mode
default['spark']['spark-env']['SPARK_MASTER_PORT'] = '7077'
default['spark']['spark-env']['SPARK_WORKER_PORT'] = '7078'
default['spark']['spark-env']['SPARK_WORKER_DIR'] =
  "/var/lib/spark-#{node['spark']['version']}"

default['spark']['spark-defaults']['spark.driver.port'] = '7079'
default['spark']['spark-defaults']['spark.blockManager.port'] = '7080'
