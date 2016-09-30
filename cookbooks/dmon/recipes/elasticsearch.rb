#create new group
group "#{node['dmon']['group']}"

#create new user
user "#{node['dmon']['user']}" do
  group "#{node['dmon']['group']}"
  system true
  shell '/bin/bash'
end

# Configuring VM level setings
bash 'vm' do
  code <<-EOH
    export ES_HEAP_SIZE=#{node['dmon']['es']['core_heap']}
    export ES_USE_GC_LOGGING=yes
    sysctl -w vm.max_map_count=262144
    swapoff -a
    EOH
end

# Install Elasticsearch
remote_file '/opt/elasticsearch-2.2.0.tar.gz' do
  source "#{node['dmon']['es']['source']}"
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
    EOH
end

file '/opt/elasticsearch-2.2.0.tar.gz' do
  action :delete
end

directory "#{node['dmon']['install_dir']}/src/logs" do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  recursive true
  action :create
end

#upload elasticsearch conf file
template "/opt/elasticsearch/config/elasticsearch.yml" do
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

execute 'setting permissions' do
  command "chown -R #{node['dmon']['user']}.#{node['dmon']['group']} /opt/elasticsearch"
end

directory "#{node['dmon']['install_dir']}/src/pid" do
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  recursive true
  action :create
end

#start elasticsearch
bash 'start elasticsearch' do
  code <<-EOH
    nohup /opt/elasticsearch/bin/elasticsearch &
    pid=$!
    echo $pid > #{node['dmon']['install_dir']}/src/pid/elasticsearch.pid
    EOH
  user "#{node['dmon']['user']}"
end
