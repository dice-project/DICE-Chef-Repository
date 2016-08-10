dmon Cookbook
============

This cookbook installs dmon from https://github.com/igabriel85/IeAT-DICE-Repository.
It also installs and configures ELK stack for collecting and visualizing data 
that is send from dmon-agents. Those agents need to be set as nodes with 
appropriate roles to work correctly. That can be don with dmon REST API on port 
5001. More information can be found on https://github.com/igabriel85/IeAT-DICE-Repository/blob/master/src/README.md

Attributes
----------

### General 
* `['dmon']['group']` - group of the user who runes the monitoring script
* `['dmon']['user']` - user who runes the monitoring script
* `['dmon']['git_url']` - git url of dmon
* `['dmon']['install_dir']` - installation directory of dmon monitoring
* `['dmon']['lsf_crt']` - logstash-forwarder certificate
* `['dmon']['lsf_key']` - logstash-forwarder key
* `['dmon']['host_ip']` - dmon ip

### Elasticsearch
* `['dmon']['es']['cluster_name']` - name of Elasticsearch cluster
* `['dmon']['es']['core_heap']` - ram restriction
* `['dmon']['es']['host_FQDN']` - fully qualified domain name of Elasticsearch host
* `['dmon']['es']['ip']` - ip of Elasticsearch host
* `['dmon']['es']['node_name']` - name of Elasticsearch node
* `['dmon']['es']['port']` - Elasticsearch port
* `['dmon']['es']['json']` - Ruby hash containing additional Elasticsearch configuration

### Kibana
* `['dmon']['kb']['host_FQDN']` - fully qualified domain name of Kibana host
* `['dmon']['kb']['ip']` - ip of Kibana host
* `['dmon']['kb']['port']` - Kibana port
* `['dmon']['kb']['os']` - Kibana host os
* `['dmon']['kb']['json']` - Ruby hash containing additional Kibana configuration

### Logstash 
* `['dmon']['ls']['cluster_name']` - name of Elasticsearch cluster
* `['dmon']['ls']['host_FQDN']` - fully qualified domain name of Logstash host
* `['dmon']['ls']['ip']` - ip of the Logstash host
* `['dmon']['ls']['l_port']` - lumberjack port of Logstash
* `['dmon']['ls']['udp_port']` - udp port of Logstash
* `['dmon']['ls']['json']` - Ruby hash containing additional Logstash configuration
