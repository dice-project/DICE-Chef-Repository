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

# Configuring VM level setings
bash 'vm' do
  code <<-EOH
    export LS_HEAP_SIZE=#{node['dmon']['ls']['core_heap']}
    sysctl -w vm.max_map_count=262144
    swapoff -a
    EOH
end

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

directory '/etc/logstash/conf.d' do
  owner dmon_user
  group dmon_group
  action :create
  recursive true
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

template "#{node['dmon']['install_dir']}/src/conf/logstash.conf" do
  source 'logstash.tmp.erb'
  owner dmon_user
  group dmon_group
  action :create
  variables({
    lPort: node['dmon']['ls']['l_port'],
    sslcert: "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.crt",
    sslkey: "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.key",
    gPort: node['dmon']['ls']['g_port'],
    udpPort: node['dmon']['ls']['udp_port'],
    EShostIP: node['dmon']['es']['ip'],
    EShostPort: node['dmon']['es']['port']
  })
end

package 'sqlite'

db = "#{node['dmon']['install_dir']}/src/db"

t = Time.now

#upload elasticsearch insert query file
template "#{db}/elasticsearch.sql" do
  source 'elasticsearch.sql.erb'
  owner dmon_user
  group dmon_group
  action :create
  variables({
    fqdn: node['dmon']['es']['host_FQDN'],
    ip: node['dmon']['es']['ip'],
    node_name: node['dmon']['es']['node_name'],
    port: node['dmon']['es']['port'],
    cluster_name: node['dmon']['es']['cluster_name'],
    core_heap: node['dmon']['es']['core_heap'],
    timestamp: t.strftime("%Y-%m-%d %H:%M:%S.%6N")
  })
end

execute 'upload es to db' do
  command "sqlite3 #{db}/dmon.db <#{db}/elasticsearch.sql"
end


#upload logstash insert query file
template "#{db}/logstash.sql" do
  source 'logstash.sql.erb'
  owner dmon_user
  group dmon_group
  action :create
  variables({
    fqdn: node['dmon']['ls']['host_FQDN'],
    ip: node['dmon']['ls']['ip'],
    lumber: node['dmon']['ls']['l_port'],
    udp: node['dmon']['ls']['udp_port'],
    cluster_name: node['dmon']['ls']['cluster_name'],
    core_heap: node['dmon']['ls']['core_heap'],
    timestamp: t.strftime("%Y-%m-%d %H:%M:%S.%6N")
  })
end

conf = "#{node['dmon']['install_dir']}/src/conf/logstash.conf"
log = "#{node['dmon']['install_dir']}/src/logs/logstash.log"

bash 'start logstash' do
  code <<-EOH
    nohup /opt/logstash/bin/logstash agent  -f #{conf} -l #{log} -w 4 &
    pid=$!
    echo $pid > #{node['dmon']['install_dir']}/src/pid/logstash.pid
    sed -i "s/pid/$pid/g" #{db}/logstash.sql
    lsconf="X'`hexdump -ve '1/1 \"%.2x\"' #{node['dmon']['install_dir']}/src/conf/logstash.conf`'"
    sed -i "s/lsconf/$lsconf/g" #{db}/logstash.sql
    sqlite3 #{db}/dmon.db <#{db}/logstash.sql
    EOH
  user dmon_user
end
