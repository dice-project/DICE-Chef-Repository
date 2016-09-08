# install sqlite3
package 'sqlite'

db = "#{node['dmon']['install_dir']}/src/db"

#upload elasticsearch conf file
template "#{node['dmon']['install_dir']}/src/conf/elasticsearch.yml" do
  source 'elasticsearch.tmp.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :clusterName => node['dmon']['es']['cluster_name'],
    :nodeName => node['dmon']['es']['node_name'],
    :esLogDir => "#{node['dmon']['install_dir']}/src/logs"
  })
end

#cp elasticsearch config file
file "/opt/elasticsearch/config/elasticsearch.yml" do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  content lazy { ::File.open("#{node['dmon']['install_dir']}/src/conf/elasticsearch.yml").read }
  action :create
end

t = Time.now

#upload elasticsearch insert query file
template "#{db}/elasticsearch.sql" do
  source 'elasticsearch.sql.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :fqdn => node['dmon']['es']['host_FQDN'],
    :ip => node['dmon']['es']['ip'],
    :node_name => node['dmon']['es']['node_name'],
    :port => node['dmon']['es']['port'],
    :cluster_name => node['dmon']['es']['cluster_name'],
    :core_heap => node['dmon']['es']['core_heap'],
    :timestamp => t.strftime("%Y-%m-%d %H:%M:%S.%6N")
  })
end

#start elasticsearch
bash 'start elasticsearch' do
  code <<-EOH
    nohup /opt/elasticsearch/bin/elasticsearch &
    pid=$!
    echo $pid > #{node['dmon']['install_dir']}/src/pid/elasticsearch.pid
    sed -i "s/pid/$pid/g" #{db}/elasticsearch.sql
    esconf="X'`hexdump -ve '1/1 \"%.2x\"' /opt/elasticsearch/config/elasticsearch.yml`'"
    sed -i "s/esconf/$esconf/g" #{db}/elasticsearch.sql
    sqlite3 #{db}/dmon.db <#{db}/elasticsearch.sql
    EOH
  user "#{node['dmon']['user']}"
end



#upload kibana conf file
template "#{node['dmon']['install_dir']}/src/conf/kibana.yml" do
  source 'kibana.tmp.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :kbPort => node['dmon']['kb']['port'],
    :kibanaPID => "#{node['dmon']['install_dir']}/src/pid/kibana.pid",
    :kibanaLog => "#{node['dmon']['install_dir']}/src/logs/kibana.log"
  })
end

#cp kibana config file
file "/opt/kibana/config/kibana.yml" do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  content lazy { ::File.open("#{node['dmon']['install_dir']}/src/conf/kibana.yml").read }
  action :create
end

t = Time.now

#upload kibana insert query file
template "#{db}/kibana.sql" do
  source 'kibana.sql.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :fqdn => node['dmon']['kb']['host_FQDN'],
    :ip => node['dmon']['kb']['ip'],
    :os => node['dmon']['kb']['os'],
    :port => node['dmon']['kb']['port'],
    :timestamp => t.strftime("%Y-%m-%d %H:%M:%S.%6N")
  })
end

#start kibana
bash 'start kibana' do
  code <<-EOH
    nohup /opt/kibana/bin/kibana &
    pid=$!
    echo $pid > #{node['dmon']['install_dir']}/src/pid/kibana.pid
    sed -i "s/pid/$pid/g" #{db}/kibana.sql
    kbconf="X'`hexdump -ve '1/1 \"%.2x\"' /opt/kibana/config/kibana.yml`'"
    sed -i "s/kbconf/$kbconf/g" #{db}/kibana.sql
    sqlite3 #{db}/dmon.db <#{db}/kibana.sql
    EOH
  user "#{node['dmon']['user']}"
end



#upload logstash conf file
template "#{node['dmon']['install_dir']}/src/conf/logstash.conf" do
  source 'logstash.tmp.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :lPort => node['dmon']['ls']['l_port'],
    :sslcert => "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.crt",
    :sslkey => "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.key",
    :gPort => node['dmon']['ls']['g_port'],
    :udpPort => node['dmon']['ls']['udp_port'],
    :EShostIP => node['dmon']['es']['ip'],
    :EShostPort => node['dmon']['es']['port']
  })
end

t = Time.now

#upload logstash insert query file
template "#{db}/logstash.sql" do
  source 'logstash.sql.erb'
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  variables({
    :fqdn => node['dmon']['ls']['host_FQDN'],
    :ip => node['dmon']['ls']['ip'],
    :lumber => node['dmon']['ls']['l_port'],
    :udp => node['dmon']['ls']['udp_port'],
    :cluster_name => node['dmon']['ls']['cluster_name'],
    :core_heap => node['dmon']['ls']['core_heap'],
    :timestamp => t.strftime("%Y-%m-%d %H:%M:%S.%6N")
  })
end

#start logstash
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
  user "#{node['dmon']['user']}"
end

