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

install_dir = node['spark']['install_dir']
conf_dir = node['spark']['spark-env']['SPARK_CONF_DIR']
spark_user = node['spark']['user']
version = node['spark']['version']

master_ip =
  node['cloudify']['runtime_properties'].fetch('master_ip', node['ipaddress'])
master = "spark://#{master_ip}:7077"

template "#{conf_dir}/spark-env.sh" do
  source 'env.sh.erb'
  action :create
  variables opts: node['spark'].fetch('spark-env', {}).to_hash
end

# YARN optimization - Disable for now
# assembly_jar = 'lib/spark-assembly-1.6.1-hadoop2.2.0.jar'
# spark_defaults = { 'spark.yarn.jar' => "local:#{spark_home}/#{assembly_jar}" }
# End YARN optimization

spark_defaults = node['spark'].fetch('spark-defaults', {}).to_hash
# TODO: Check what parameters can be tweaked on Spark installations and where
# do those settings reside. Tadej's hunch would be that spark-defaults is that
# place, but we need to verify this.
spark_defaults.merge!(node['cloudify']['properties']['configuration'].to_hash)
spark_defaults['spark.master'] = master

template "#{conf_dir}/spark-defaults.conf" do
  source 'defaults.conf.erb'
  action :create
  variables opts: spark_defaults
end

# Init scripts are done in configure phase because master_ip is not known at
# creation time.
%w(master worker).each do |name|
  template "/etc/init/spark-#{name}-#{version}.conf" do
    source 'spark.conf.erb'
    action :create
    variables(
      spark_home: install_dir,
      type: node['spark']['type'],
      user: spark_user,
      conf_dir: conf_dir,
      master: name == 'worker' ? master : '',
      # Next line is just ridiculous, but spark is a bit inconsistent when it
      # comes to naming various things.
      script_name: name == 'master' ? 'master' : 'slave'
    )
  end
end
