#
# Cookbook Name:: spark
# Recipe:: configure
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

spark_home = "#{node['spark']['prefix']}/#{node['spark']['version']}"
spark_conf = node['spark']['spark-env']['SPARK_CONF_DIR']
spark_user = node['spark']['user']

spark_env = if node['spark'].key?('spark-env')
              node['spark']['spark-env'].to_hash
            else
              {}
            end
spark_env.merge!(
  'SPARK_LOCAL_IP' => node['ipaddress'],
  'SPARK_MASTER_HOST' => node['ipaddress']
)
template "#{spark_conf}/spark-env.sh" do
  source 'env.sh.erb'
  action :create
  variables opts: spark_env
end

# YARN mode stuff
assembly_jar = 'lib/spark-assembly-1.6.1-hadoop2.2.0.jar'
spark_defaults = { 'spark.yarn.jar' => "local:#{spark_home}/#{assembly_jar}" }
# End YARN mode stuff

if node['spark'].key?('spark-defaults')
  spark_defaults = node['spark']['spark-defaults'].merge(spark_defaults)
end

# TODO: Check what parameters can be tweaked on Spark installations and where
# do those settings reside. Tadej's hunch would be that spark-defaults is that
# place, but we need to verify this.
spark_defaults.merge!(node['cloudify']['properties']['configuration'].to_hash)

template "#{spark_conf}/spark-defaults.conf" do
  source 'defaults.conf.erb'
  action :create
  variables opts: spark_defaults
end

# Init script
master = ''
if node['cloudify']['runtime_properties'].key?('master_ip')
  master_ip = node['cloudify']['runtime_properties']['master_ip']
  master = "spark://#{master_ip}:7077"
end

template "/etc/init/spark-#{node['spark']['type']}.conf" do
  source 'spark.conf.erb'
  action :create
  variables(
    spark_home: spark_home,
    type: node['spark']['type'],
    user: spark_user,
    conf_dir: spark_conf,
    master: master,
    # Next line is just ridiculous, but spark is a bit inconsistent when it
    # comes to naming various things.
    script_name: node['spark']['type'] == 'master' ? 'master' : 'slave'
  )
end
