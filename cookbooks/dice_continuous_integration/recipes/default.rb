#
# Cookbook Name:: dice_continuous_integration
# Recipe:: default
#
# Copyright 2017, XLAB
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

apt_repository 'jenkins' do
	uri 'http://pkg.jenkins.io/debian'
	distribution 'binary/'
	key 'https://pkg.jenkins.io/debian/jenkins-ci.org.key'
	action :add
end

package 'jenkins' do
	action :install
end

service 'jenkins' do
	action :restart
end
