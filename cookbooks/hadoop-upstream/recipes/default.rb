#
# Cookbook Name:: hadoop-upstream
# Recipe:: default
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

hadoop_home = "#{node["prefix"]}/#{node["hadoop-version"]}"

remote_file "/tmp/#{node["hadoop-version"]}.tar.gz" do
  source "#{node["apache-mirror"]}/dist/hadoop/common/"\
         "#{node["hadoop-version"]}/#{node["hadoop-version"]}.tar.gz"
  checksum node["sha256-checksum"]
  action :create
end

execute "Extract hadoop" do
  command "tar -xf /tmp/#{node["hadoop-version"]}.tar.gz"
  cwd node["prefix"]
  group "root"
  user "root"
  creates hadoop_home
end

directory node["conf-dir"] do
  mode "0755"
  owner "root"
  group "root"
  action :create
  recursive true
end

["core-site", "hdfs-site", "yarn-site", "capacity-scheduler"].each do |name|
  template "#{node["conf-dir"]}/#{name}.xml" do
    source "site.xml.erb"
    mode "0644"
    owner "root"
    group "root"
    action :create
    variables :opts => node["#{name}"]
    only_if { node.key?("#{name}") }
  end
end

%w(hadoop yarn).each do |name|
  template "#{node["conf-dir"]}/#{name}-env.sh" do
    source "env.sh.erb"
    mode "0755"
    owner "root"
    group "root"
    action :create
    variables :opts => node["#{name}-env"]
    only_if { node.key?("#{name}-env") }
  end
end
