#
# Cookbook Name:: hadoop
# Recipe:: yarn_configure
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

conf_dir = node['hadoop']['conf_dir']
hadoop_group = node['hadoop']['group']
yarn_user = node['hadoop']['yarn_user']

# Prepare common yarn configuration
config = {}
%w(yarn-site mapred-site capacity-scheduler).each do |name|
  config[name] = node['hadoop'].fetch(name, {}).to_hash
end

ruby_block 'Lazy load FQDN' do
  # OHAI is real pain to work with when it comes to dynamic values. We must
  # query it ruby_block in order to delay execution from compile phase to
  # converge phase or we will get bad value.
  block do
    config['yarn-site']['yarn.resourcemanager.hostname'] =
      if node['cloudify']['runtime_properties'].key?('resourcemanager_addr')
        node['cloudify']['runtime_properties']['resourcemanager_addr']
      else
        node['fqdn']
      end
  end
end

[
  node['hadoop']['yarn-env']['YARN_LOG_DIR'],
  node['hadoop']['yarn-env']['YARN_PID_DIR']
].each do |folder|
  directory folder do
    mode '0700'
    owner yarn_user
    group hadoop_group
    action :create
    recursive true
  end
end

config.each do |name, data|
  template "#{conf_dir}/#{name}.xml" do
    source 'site.xml.erb'
    mode '0644'
    owner 'root'
    group 'root'
    action :create
    variables opts: data
  end
end

template "#{conf_dir}/yarn-env.sh" do
  source 'env.sh.erb'
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  variables opts: node['hadoop']['yarn-env'].to_hash
  only_if { node['hadoop'].key?('yarn-env') }
end

# For some mysterious reason, YARN reads this file too, so we supply it
template "#{conf_dir}/hadoop-env.sh" do
  source 'env.sh.erb'
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  variables opts: node['hadoop']['hadoop-env'].to_hash
  only_if { node['hadoop'].key?('hadoop-env') }
end
