#General attributes
default['dmon']['group'] = 'ubuntu'
default['dmon']['user'] = 'ubuntu'

default['dmon']['git_url'] = 'git://github.com/igabriel85/IeAT-DICE-Repository.git'
default['dmon']['install_dir'] = '/opt/IeAT-DICE-Repository'

default['dmon']['lsf_crt'] = nil
default['dmon']['lsf_key'] = nil
default['dmon']['host_ip'] = '10.211.55.100'

#Elasticsearch configuration attributes
default['dmon']['es']['cluster_name'] = "diceMonit"
default['dmon']['es']['core_heap'] = "1g"
default['dmon']['es']['host_FQDN'] = "monitor"
default['dmon']['es']['ip'] = "127.0.0.1"
default['dmon']['es']['node_name'] = "esCoreMaster"
default['dmon']['es']['port'] = 9200
default['dmon']['es']['json'] = nil

#Kibana configuration attributes
default['dmon']['kb']['host_FQDN'] = "monitor"
default['dmon']['kb']['ip'] = "127.0.0.1"
default['dmon']['kb']['port'] = 5601
default['dmon']['kb']['os'] = "ubuntu"
default['dmon']['kb']['json'] = nil

#Logstash configuration attributes
default['dmon']['ls']['cluster_name'] = "diceMonit"
default['dmon']['ls']['host_FQDN'] = "monitor"
default['dmon']['ls']['ip'] = "127.0.0.1"
default['dmon']['ls']['l_port'] = 5000
default['dmon']['ls']['udp_port'] = 25680
default['dmon']['ls']['json'] = nil
