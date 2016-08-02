#General attributes
default['dmon']['group'] = 'ubuntu'
default['dmon']['user'] = 'ubuntu'

default['dmon']['git_url'] = 'https://github.com/igabriel85/IeAT-DICE-Repository.git'
default['dmon']['install_dir'] = '/opt/IeAT-DICE-Repository'

default['dmon']['host_ip'] = '10.211.55.100'
default['dmon']['openssl'] = '[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = TG
ST = Togo
L =  Lome
O = Private company
CN = *
[v3_req]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:TRUE
subjectAltName = @alt_names
[alt_names]
IP.1 = 10.211.55.100
[v3_ca]
keyUsage = digitalSignature, keyEncipherment
subjectAltName = IP:10.211.55.100'

#Elasticsearch configuration attributes
default['dmon']['es']['cluster_name'] = "diceMonit"
default['dmon']['es']['core_heap'] = "1g"
default['dmon']['es']['host_FQDN'] = "monitor"
default['dmon']['es']['ip'] = "127.0.0.1"
default['dmon']['es']['node_name'] = "esCoreMaster"
default['dmon']['es']['port'] = 9200
default['dmon']['es']['json'] = {
  :ESClusterName => "#{node['dmon']['es']['cluster_name']}",
  :ESCoreHeap => "#{node['dmon']['es']['core_heap']}",
  :HostFQDN => "#{node['dmon']['es']['host_FQDN']}",
  :IP => "#{node['dmon']['es']['ip']}",
  :NodeName => "#{node['dmon']['es']['node_name']}",
  :NodePort => node['dmon']['es']['port']
}

#Kibana configuration attributes
default['dmon']['kb']['host_FQDN'] = "monitor"
default['dmon']['kb']['ip'] = "127.0.0.1"
default['dmon']['kb']['port'] = 5601
default['dmon']['kb']['os'] = "ubuntu"
default['dmon']['kb']['json'] = {
  :HostFQDN => "#{node['dmon']['kb']['host_FQDN']}",
  :IP => "#{node['dmon']['kb']['ip']}",
  :KBPort => node['dmon']['kb']['port'],
  :OS => "#{node['dmon']['kb']['os']}"
}

#Logstash configuration attributes
default['dmon']['ls']['cluster_name'] = "diceMonit"
default['dmon']['ls']['host_FQDN'] = "monitor"
default['dmon']['ls']['ip'] = "127.0.0.1"
default['dmon']['ls']['l_port'] = 5000
default['dmon']['ls']['udp_port'] = 25680
default['dmon']['ls']['json'] = {
  :ESClusterName => "#{node['dmon']['ls']['cluster_name']}",
  :HostFQDN => "#{node['dmon']['ls']['host_FQDN']}",
  :IP => "#{node['dmon']['ls']['ip']}",
  :LPort => node['dmon']['ls']['l_port'],
  :udpPort => node['dmon']['ls']['udp_port']
}

