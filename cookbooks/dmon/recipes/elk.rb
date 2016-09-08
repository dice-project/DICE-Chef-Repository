# Install kibana
remote_file '/opt/kibana-4.4.1-linux-x64.tar.gz' do
  source 'https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz'
  action :create_if_missing
end

directory '/opt/kibana' do
  action :create
end

execute 'extract kibana' do
  command 'tar xvf kibana-4.4.1-linux-x64.tar.gz -C kibana --strip-components=1'
  cwd '/opt'
  not_if { ::File.directory?('/opt/kibana/bin') }
end

remote_file '/opt/kibana/optimize/bundles/src/ui/public/images/kibana.svg' do
  source 'https://github.com/igabriel85/IeAT-DICE-Repository/releases/download/logov01/kibana.svg'
  action :create_if_missing
end

# Configuring VM level setings
bash 'vm' do
  code <<-EOH
    export ES_HEAP_SIZE=#{node['dmon']['es']['core_heap']}
    export LS_HEAP_SIZE=#{node['dmon']['ls']['core_heap']}
    export ES_USE_GC_LOGGING=yes
    sysctl -w vm.max_map_count=262144
    swapoff -a
    EOH
end

# Install Elasticsearch
remote_file '/opt/elasticsearch-2.2.0.tar.gz' do
  source 'https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.2.0/elasticsearch-2.2.0.tar.gz'
  action :create_if_missing
end

directory '/opt/elasticsearch' do
  action :create
end

execute 'extract elasticsearch' do
  command 'tar xvf elasticsearch-2.2.0.tar.gz -C elasticsearch --strip-components=1'
  cwd '/opt'
  not_if { ::File.directory?('/opt/elasticsearch/bin') }
end

file '/opt/elasticsearch/config/elastcisearch.yml' do
  action :delete
end


# Install Marvel
bash 'install marvel' do
  code <<-EOH
    /opt/elasticsearch/bin/plugin install license
    /opt/elasticsearch/bin/plugin install marvel-agent
    /opt/kibana/bin/kibana plugin --install elasticsearch/marvel/2.2.0
    EOH
end


# Install Logstash
remote_file '/opt/logstash-2.2.1.tar.gz' do
  source 'https://download.elastic.co/logstash/logstash/logstash-2.2.1.tar.gz'
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

file '/opt/kibana-4.4.1-linux-x64.tar.gz' do
  action :delete
end

file '/opt/elasticsearch-2.2.0.tar.gz' do
  action :delete
end

file '/opt/logstash-2.2.1.tar.gz' do
  action :delete
end

