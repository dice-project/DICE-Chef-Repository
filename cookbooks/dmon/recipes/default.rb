#create new group
group "#{node['dmon']['group']}"

#create new user
user "#{node['dmon']['user']}" do
  group "#{node['dmon']['group']}"
  system true
  shell '/bin/bash'
end

#clone git repository 
git "#{node['dmon']['install_dir']}" do
  repository "#{node['dmon']['git_url']}"
  revision 'master'
  action :sync
  not_if { File.exist?("#{node['dmon']['install_dir']}") }
end

#change the bootstrap file that is executed when installing elk stack
ruby_block 'change bootstrap.sh' do
  block do
    f = Chef::Util::FileEdit.new("#{node['dmon']['install_dir']}/src/bootstrap.sh") 
    f.search_file_replace(/marvel\/latest/, 'marvel/2.2.0') 
    f.write_file
  end
  action :run
end

#change install_dir owner to previously created user
execute 'chown' do
  command "chown -R #{node['dmon']['user']}.#{node['dmon']['group']} #{node['dmon']['install_dir']}"
  not_if "stat -c %U #{node['dmon']['install_dir']} | grep #{node['dmon']['user']}"
end

#create empty dmon-controller log file
file "#{node['dmon']['install_dir']}/src/logs/dmon-controller.log" do
  content ''
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  not_if { File.exist?("#{node['dmon']['install_dir']}/src/logs/dmon-controller.log") }
end

#install additional python packages
python_runtime 'dmonPy' do
  version '2.7'
end

python_virtualenv 'dmonEnv' do
  path "#{node['dmon']['install_dir']}/dmonEnv"
  python 'dmonPy'
  user "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
end

pip_requirements 'dmonPip' do
  path "#{node['dmon']['install_dir']}/src/requirements.txt"
  virtualenv 'dmonEnv'
  user "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
end

#install elk stack
python_execute 'start.py -i -p 5001' do
  virtualenv 'dmonEnv'
  cwd "#{node['dmon']['install_dir']}/src"
  not_if { File.exist?("/opt/logstash") }
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
  
  #upload openssl conf file
  template "#{node['dmon']['install_dir']}/src/keys/openssl.cnf" do
    source 'openssl.cnf.erb'
    owner "#{node['dmon']['user']}"
    group "#{node['dmon']['group']}"
    action :create
  end  
  
  #generate cerificate
  execute 'generate crt' do
    command 'openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt -config openssl.cnf'
    cwd "#{node['dmon']['install_dir']}/src/keys"
    user "#{node['dmon']['user']}"
  end

end

#start dmon-controller as previously created user
python_execute 'start.py -p 5001 &' do
  virtualenv 'dmonEnv'
  cwd "#{node['dmon']['install_dir']}/src"
  user "#{node['dmon']['user']}"
end

#generate hash for Elasticsearch configuration
es = {
  :ESClusterName => "#{node['dmon']['es']['cluster_name']}",
  :ESCoreHeap => "#{node['dmon']['es']['core_heap']}",
  :HostFQDN => "#{node['dmon']['es']['host_FQDN']}",
  :IP => "#{node['dmon']['es']['ip']}",
  :NodeName => "#{node['dmon']['es']['node_name']}",
  :NodePort => node['dmon']['es']['port']
}

es_hash = node['dmon']['es']['json'].to_h
es_hash.merge!(es)

#send put to rest api for Elasticsearch config
http_request 'es config' do
  action :put
  url 'http://localhost:5001/dmon/v1/overlord/core/es/config'
  message (es_hash.to_json)
  headers({'Content-Type' => 'application/json'})
end

#send post to rest api for Elasticsearch service start
http_request 'es start' do
  action :post
  url 'http://localhost:5001/dmon/v1/overlord/core/es'
end

#generate hash for Kibana configuration
kb = {
  :HostFQDN => "#{node['dmon']['kb']['host_FQDN']}",
  :IP => "#{node['dmon']['kb']['ip']}",
  :KBPort => node['dmon']['kb']['port'],
  :OS => "#{node['dmon']['kb']['os']}"
}

kb_hash = node['dmon']['kb']['json'].to_h
kb_hash.merge!(kb)

#send put to rest api for Kibana config
http_request 'kb config' do
  action :put
  url 'http://localhost:5001/dmon/v1/overlord/core/kb/config'
  message (kb.to_json)
  headers({'Content-Type' => 'application/json'})
end

#send post to rest api for Kibana service start
http_request 'kb start' do
  action :post
  url 'http://localhost:5001/dmon/v1/overlord/core/kb'
end

#generate hash for Logstash configuration
ls = {
  :ESClusterName => "#{node['dmon']['ls']['cluster_name']}",
  :HostFQDN => "#{node['dmon']['ls']['host_FQDN']}",
  :IP => "#{node['dmon']['ls']['ip']}",
  :LPort => node['dmon']['ls']['l_port'],
  :udpPort => node['dmon']['ls']['udp_port']
}

ls_hash = node['dmon']['ls']['json'].to_h
ls_hash.merge!(ls)

#send put to rest api for Logstash config
http_request 'ls config' do
  action :put
  url 'http://localhost:5001/dmon/v1/overlord/core/ls/config'
  message (ls.to_json)
  headers({'Content-Type' => 'application/json'})
end

#send post to rest api for Logstash service start
http_request 'ls start' do
  action :post
  url 'http://localhost:5001/dmon/v1/overlord/core/ls'
end
