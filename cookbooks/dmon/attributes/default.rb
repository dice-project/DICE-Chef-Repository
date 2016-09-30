#General attributes
default['dmon']['group'] = 'ubuntu'
default['dmon']['user'] = 'ubuntu'

default['dmon']['git_url'] = 'git://github.com/igabriel85/IeAT-DICE-Repository.git'
default['dmon']['install_dir'] = '/opt/IeAT-DICE-Repository'

default['dmon']['port'] = '5001'
default['dmon']['ip'] = nil

default['dmon']['lsf_crt'] = nil
default['dmon']['lsf_key'] = nil
default['dmon']['openssl_conf'] = "
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = SL
ST = Slovenia
L =  Ljubljana
O = Xlab
CN = *
[v3_req]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:TRUE
subjectAltName = IP:ipaddresses
[v3_ca]
keyUsage = digitalSignature, keyEncipherment
subjectAltName = IP:ipaddresses
"

#Elasticsearch configuration attributes
default['dmon']['es']['source'] = 'https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.2.0/elasticsearch-2.2.0.tar.gz'
default['dmon']['es']['cluster_name'] = "diceMonit"
default['dmon']['es']['core_heap'] = "1g"
default['dmon']['es']['host_FQDN'] = "monitor"
default['dmon']['es']['ip'] = "127.0.0.1"
default['dmon']['es']['node_name'] = "esCoreMaster"
default['dmon']['es']['port'] = 9200

#Kibana configuration attributes
default['dmon']['kb']['source'] = 'https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz'
default['dmon']['kb']['host_FQDN'] = "monitor"
default['dmon']['kb']['ip'] = "127.0.0.1"
default['dmon']['kb']['port'] = 5601
default['dmon']['kb']['os'] = "ubuntu"

#Logstash configuration attributes
default['dmon']['ls']['source'] = 'https://download.elastic.co/logstash/logstash/logstash-2.2.1.tar.gz'
default['dmon']['ls']['cluster_name'] = "diceMonit"
default['dmon']['ls']['core_heap'] = "512m"
default['dmon']['ls']['host_FQDN'] = "monitor"
default['dmon']['ls']['ip'] = "127.0.0.1"
default['dmon']['ls']['l_port'] = 5000
default['dmon']['ls']['g_port'] = 5002
default['dmon']['ls']['udp_port'] = 25826
