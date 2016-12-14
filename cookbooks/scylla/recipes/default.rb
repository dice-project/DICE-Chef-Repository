# Cookbook Name:: scylla
# Recipe:: default
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

# This recipe will install scylla data files and init scripts.

# Centos packages
package 'epel-release' do
  only_if { platform?('centos') }
end

node['scylla']['centos']['repos'].each do |repo|
  yum_repository repo[:id] do
    description repo[:desc]
    baseurl repo[:url]
    gpgcheck false
    enabled true
    action :create
    only_if { platform?('centos') }
  end
end

# Ubuntu packages
node['scylla']['ubuntu']['repos'].each do |repo|
  apt_repository repo[:id] do
    uri repo[:uri]
    distribution node['lsb']['codename']
    components repo[:components]
    arch repo[:arch]
    only_if { platform?('ubuntu') }
  end
end

package 'scylla' do
  action :install
  options '--force-yes' if platform?('ubuntu')
end
