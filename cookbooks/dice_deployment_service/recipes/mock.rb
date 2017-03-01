#
# Cookbook Name:: dice_deployment_service
# Recipe:: mock
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

# WARNING: This recipe should only be used for testing purposes!

bash 'Create dummy DDS certificate' do
  code <<-EOH
    openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
      -subj "/C=SI/CN=0.0.0.0" \
      -keyout #{node['cloudify']['runtime_properties']['dds_key']} \
      -out    #{node['cloudify']['runtime_properties']['dds_crt']}
    EOH
end
