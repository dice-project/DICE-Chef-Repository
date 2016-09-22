#
# Cookbook Name:: storm
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

default['storm']['install_dir'] = '/usr/share/storm'
default['storm']['user'] = 'storm'

default['storm']['tarball'] =
  'http://www.apache.si/storm/apache-storm-1.0.1/apache-storm-1.0.1.tar.gz'
default['storm']['checksum'] =
  '1574c08d8cfb6bc7509c78871e98a535f1386d6ca50fa71c880c39e8800620bf'
