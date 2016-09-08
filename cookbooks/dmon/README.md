dmon Cookbook
============

This cookbook installs dmon from https://github.com/igabriel85/IeAT-DICE-Repository.
It also installs and configures ELK stack for collecting and visualizing data 
that is sent from dmon-agents.

## Cookbook requirements

- apt
- git
- java
- poise-python

## Recipes

- `dmon::default` - installs and starts dmon-controller
- `dmon::elk` - installs elk stack
- `dmon::elk_conf` - configures and starts elk stack
- `dmon::reset` - stops elk and dmon-controller, deletes database

## Install and run 

Use run list:
```
- recipe[apt::default]
- recipe[git::default]
- recipe[java::default]
- recipe[dmon::default]
- recipe[dmon::elk]
- recipe[dmon::elk_conf]
```
Installs, configers, starts dmon-controller and elk stack.

## Reset dmon

Use run list
```
- recipe[dmon::reset]
- recipe[dmon::elk_conf]
```
Deletes database, stops all programse. It than reconfigures and starts 
everything again.

# Attributes

### General 
* `['dmon']['group']` - group of the user who runes the monitoring script
* `['dmon']['user']` - user who runes the monitoring script
* `['dmon']['git_url']` - git url of dmon
* `['dmon']['install_dir']` - installation directory of dmon monitoring
* `['dmon']['lsf_crt']` - logstash-forwarder certificate
* `['dmon']['lsf_key']` - logstash-forwarder key
* `['dmon']['openssl_conf']` - openssl configuration file

### Elasticsearch
* `['dmon']['es']['cluster_name']` - name of Elasticsearch cluster
* `['dmon']['es']['core_heap']` - ram restriction
* `['dmon']['es']['host_FQDN']` - fully qualified domain name of Elasticsearch host
* `['dmon']['es']['ip']` - ip of Elasticsearch host
* `['dmon']['es']['node_name']` - name of Elasticsearch node
* `['dmon']['es']['port']` - Elasticsearch port

### Kibana
* `['dmon']['kb']['host_FQDN']` - fully qualified domain name of Kibana host
* `['dmon']['kb']['ip']` - ip of Kibana host
* `['dmon']['kb']['port']` - Kibana port
* `['dmon']['kb']['os']` - Kibana host os

### Logstash 
* `['dmon']['ls']['cluster_name']` - name of Elasticsearch cluster
* `['dmon']['ls']['host_FQDN']` - fully qualified domain name of Logstash host
* `['dmon']['ls']['ip']` - ip of the Logstash host
* `['dmon']['ls']['l_port']` - lumberjack port of Logstash
* `['dmon']['ls']['g_port']` - graphite port of Logstash
* `['dmon']['ls']['udp_port']` - udp port of Logstash
