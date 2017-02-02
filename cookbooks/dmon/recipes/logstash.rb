# Cookbook Name:: dmon
# Recipe:: logstash
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

install_dir = node['dmon']['ls']['install_dir']
dmon_user = node['dmon']['user']
dmon_group = node['dmon']['group']

ls_tar = "#{Chef::Config[:file_cache_path]}/ls.tar.gz"
remote_file ls_tar do
  source node['dmon']['ls']['source']
  checksum node['dmon']['ls']['checksum']
  action :create
end

poise_archive ls_tar do
  destination install_dir
end

file "#{node['dmon']['install_dir']}/src/logs/logstash.log" do
  owner dmon_user
  group dmon_group
end

execute 'Setting ls permissions' do
  command "chown -R #{dmon_user}:#{dmon_group} #{install_dir}"
end

# If logstash-forwarder certificate and key are set
if node['dmon']['lsf_crt'] && node['dmon']['lsf_key']

  file "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.crt" do
    content node['dmon']['lsf_crt']
    owner dmon_user
    group dmon_group
    action :create
  end

  file "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.key" do
    content node['dmon']['lsf_key']
    owner dmon_user
    group dmon_group
    action :create
  end

else

  if node['dmon']['ip']
    node['dmon']['openssl_conf'].sub! 'ipaddresses', node['dmon']['ip']
  else
    node['dmon']['openssl_conf'].sub! 'ipaddresses', node['ipaddress']
  end

  file "#{node['dmon']['install_dir']}/src/keys/openssl.cnf" do
    content node['dmon']['openssl_conf']
    owner dmon_user
    group dmon_group
    action :create
  end

  execute 'generate crt' do
    command 'openssl req -x509 -batch -nodes -days 6000 -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt -config openssl.cnf'
    cwd "#{node['dmon']['install_dir']}/src/keys"
    user dmon_user
  end

end

bash 'logrotate' do
  code <<-EOH
    echo "#{node['dmon']['install_dir']}/src/logs/logstash.log{
    size 20M
    create 777 ubuntu ubuntu
    rotate 4
    }" >> /etc/logrotate.conf
    cd /etc
    logrotate -s /var/log/logstatus logrotate.conf
    EOH
end

template '/etc/init/dmon-ls.conf' do
  source 'dmon-ls.conf.erb'
  variables(
    user: dmon_user,
    group: dmon_group,
    install_dir: install_dir,
    conf_file: "#{node['dmon']['install_dir']}/src/conf/logstash.conf",
    log_file: "#{node['dmon']['install_dir']}/src/logs/logstash.log"
  )
end
