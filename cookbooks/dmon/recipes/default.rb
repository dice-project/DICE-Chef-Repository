#create new group
group "#{node['dmon']['group']}"

#create new user
user "#{node['dmon']['user']}" do
  group "#{node['dmon']['group']}"
  system true
  shell '/bin/bash'
  password "#{node['dmon']['passwd']}"
end

#execute apt-get update
apt_update 'all platforms' do
  frequency 86400
  action :periodic
end

#install python and git
package ['python-dev', 'python-lxml', 'python-pip', 'git']  do
  action :install
end

#clone git repository 
execute 'clone git repo' do
  command "sudo git clone #{node['dmon']['git_url']}"
  cwd '/opt'
  not_if { File.exist?("#{node['dmon']['install_dir']}") }
end

#change the bootstrap file that is executed when installing elk stack
ruby_block 'change bootstrap.sh location' do
  block do
    text = File.read("#{node['dmon']['install_dir']}/src/start.py")
    new_contents = text.gsub(/.\/bootstrap/, "../bootstrap")
    puts new_contents
    File.open("#{node['dmon']['install_dir']}/src/start.py", "w") {|file| file.puts new_contents }
  end
  action :run
end

#change /opt owner to previously created user
execute 'chown' do
  command "sudo chown -R #{node['dmon']['user']}.#{node['dmon']['group']} /opt"
  not_if "stat -c %U #{node['dmon']['install_dir']} | grep #{node['dmon']['user']}"
end

#install additional python packages
execute 'pip install' do
  command 'sudo pip install -r requirements.txt'
  cwd "#{node['dmon']['install_dir']}/src"
  not_if 'python -c "import Flask"'
end

#create empty dmon-controller log file
file "#{node['dmon']['install_dir']}/src/logs/dmon-controller.log" do
  content ''
  owner "#{node['dmon']['user']}"
  group "#{node['dmon']['group']}"
  not_if { File.exist?("#{node['dmon']['install_dir']}/src/logs/dmon-controller.log") }
end

#install elk stack
execute 'install elk' do
  command 'sudo python start.py -i -p 5001'
  cwd "#{node['dmon']['install_dir']}/src"
  not_if { File.exist?("/opt/logstash") }
end

#generate logstash-forwarder certificate
bash 'generate crt' do
  cwd "#{node['dmon']['install_dir']}/src/keys"
  code <<-EOH
  rm logstash-forwarder.crt && rm logstash-forwarder.key
  echo "#{node['dmon']['openssl']}" >> openssl.cnf
  sudo openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt -config openssl.cnf
  EOH
end

#start dmon-controller as previously created user
execute 'start dmon monitoring' do
  command 'python start.py -p 5001 &'
  cwd "#{node['dmon']['install_dir']}/src"
  user "#{node['dmon']['user']}"
end

#send put to rest api for Elasticsearch config
http_request 'es config' do
  action :put
  url 'http://localhost:5001/dmon/v1/overlord/core/es/config'
  message (node['dmon']['es']['json'].to_json)
  headers({'Content-Type' => 'application/json'})
end

#send post to rest api for Elasticsearch service start
http_request 'es start' do
  action :post
  url 'http://localhost:5001/dmon/v1/overlord/core/es'
end

#send put to rest api for Kibana config
http_request 'kb config' do
  action :put
  url 'http://localhost:5001/dmon/v1/overlord/core/kb/config'
  message (node['dmon']['kb']['json'].to_json)
  headers({'Content-Type' => 'application/json'})
end

#send post to rest api for Kibana service start
http_request 'kb start' do
  action :post
  url 'http://localhost:5001/dmon/v1/overlord/core/kb'
end

#send put to rest api for Logstash config
http_request 'ls config' do
  action :put
  url 'http://localhost:5001/dmon/v1/overlord/core/ls/config'
  message (node['dmon']['ls']['json'].to_json)
  headers({'Content-Type' => 'application/json'})
end

#send post to rest api for Logstash service start
http_request 'ls start' do
  action :post
  url 'http://localhost:5001/dmon/v1/overlord/core/ls'
end
