dmon Cookbook
============

This cookbook installs dmon which contains controller REST API and ELK stack for viewing logs.

Attributes
----------

### General 
* `['dmon']['group']` - group of the user who runes the monitoring script
* `['dmon']['user']` - user who runes the monitoring script
* `['dmon']['passwd']` - user password (for testing)
* `['dmon']['git_url']` - git url of dmon
* `['dmon']['install_dir']` - installation directory of dmon monitoring
* `['dmon']['openssl']` - configuration file content for generating logstash-forwarder certificate 

### Elasticsearch
* `['dmon']['es']['cluster_name']` - name of Elasticsearch cluster
* `['dmon']['es']['core_heap']` - ram restriction
* `['dmon']['es']['host_FQDN']` - fully qualified domain name of Elasticsearch host
* `['dmon']['es']['ip']` - ip of Elasticsearch host
* `['dmon']['es']['node_name']` - name of Elasticsearch node
* `['dmon']['es']['port']` - Elasticsearch port
* `['dmon']['es']['json']` - Ruby hash of Elasticsearch configuration

### Kibana
* `['dmon']['kb']['host_FQDN']` - fully qualified domain name of Kibana host
* `['dmon']['kb']['ip']` - ip of Kibana host
* `['dmon']['kb']['port']` - Kibana port
* `['dmon']['kb']['os']` - Kibana host os
* `['dmon']['kb']['json']` - Ruby hash of Kibana configuration

### Logstash 
* `['dmon']['ls']['cluster_name']` - name of Elasticsearch cluster
* `['dmon']['ls']['host_FQDN']` - fully qualified domain name of Logstash host
* `['dmon']['ls']['ip']` - ip of the Logstash host
* `['dmon']['ls']['l_port']` - lumberjack port of Logstash
* `['dmon']['ls']['udp_port']` - udp port of Logstash
* `['dmon']['kb']['json']` - Ruby hash of Logstash configuration
