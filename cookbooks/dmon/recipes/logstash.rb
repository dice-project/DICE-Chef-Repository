# Configuring VM level setings
bash 'vm' do
  code <<-EOH
    export LS_HEAP_SIZE=#{node['dmon']['ls']['core_heap']}
    sysctl -w vm.max_map_count=262144
    swapoff -a
    EOH
end

# Install Logstash
remote_file '/opt/logstash-2.2.1.tar.gz' do
  source "#{node['dmon']['ls']['source']}"
  action :create_if_missing
end

directory '/opt/logstash' do
  action :create
end

execute 'extract logstash' do
  command 'tar xvf logstash-2.2.1.tar.gz -C logstash --strip-components=1'
  cwd '/opt'
  not_if { ::File.directory?('/opt/logstash/bin') }
end

file "#{node['dmon']['install_dir']}/src/logs/logstash.log" do
  action :create
end

#if logstash-forwarder certificate and key are set
if node['dmon']['lsf_crt'] && node['dmon']['lsf_key']
  
  #create files 
  file "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.crt" do
    content "#{node['dmon']['lsf_crt']}"
    owner "#{node['dmon']['user']}"
    group "#{node['dmon']['group']}"
    action :create
  end

  file "#{node['dmon']['install_dir']}/src/keys/logstash-forwarder.key" do
    content "#{node['dmon']['lsf_key']}"
    owner "#{node['dmon']['user']}"
    group "#{node['dmon']['group']}"
    action :create
  end

else

  #set ip
  if node['dmon']['ip']
    node['dmon']['openssl_conf'].sub! 'ipaddresses', node['dmon']['ip']
  else
    node['dmon']['openssl_conf'].sub! 'ipaddresses', node['ipaddress']
  end
  
  #create openssl conf file
  file "#{node['dmon']['install_dir']}/src/keys/openssl.cnf" do
    content "#{node['dmon']['openssl_conf']}"
    owner "#{node['dmon']['user']}"
    group "#{node['dmon']['group']}"
    action :create
  end  
  

  #generate cerificate
  execute 'generate crt' do
    command 'openssl req -x509 -batch -nodes -days 6000 -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt -config openssl.cnf'
    cwd "#{node['dmon']['install_dir']}/src/keys"
    user "#{node['dmon']['user']}"
  end

end

directory '/etc/logstash/conf.d' do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  action :create
  recursive true
end


# Setting up logrotate
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

# Finishing touches
directory '/opt/DmonBackup' do
  action :create
end

execute 'setting permissions' do
  command "chown -R #{node['dmon']['user']}.#{node['dmon']['group']} /opt"
end

file '/opt/logstash-2.2.1.tar.gz' do
  action :delete
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

#start logstash
conf = "#{node['dmon']['install_dir']}/src/conf/logstash.conf"
log = "#{node['dmon']['install_dir']}/src/logs/logstash.log"

bash 'start logstash' do
  code <<-EOH
    nohup /opt/logstash/bin/logstash agent  -f #{conf} -l #{log} -w 4 &
    pid=$!
    echo $pid > #{node['dmon']['install_dir']}/src/pid/logstash.pid
    EOH
  user "#{node['dmon']['user']}"
end

