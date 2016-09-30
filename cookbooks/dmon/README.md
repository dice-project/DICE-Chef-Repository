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

- `dmon::default` - installs and starts dmon-controller (requires apt and git)
- `dmon::elasticsearch` - installs and starts elasticsearch (requires java)
- `dmon::kibana` - installs and starts kibana
- `dmon::logstash` - installs and starts logstash (requires java and default)
- `dmon::reset` - deletes database and restarts dmon-controller

## Install and run 

Use run list:
```
- recipe[apt::default]
- recipe[git::default]
- recipe[java::default]
- recipe[dmon::default]
- recipe[dmon::elasticsearch]
- recipe[dmon::kibana]
- recipe[dmon::logstash]
```
Installs, configures, starts dmon-controller and elk stack.

## Reset dmon

Use run list
```
- recipe[dmon::reset]
```
Deletes database, stops logstash and restarts dmon-controller.

# Attributes

### General 
* `['dmon']['group']` - group of the user who runes the monitoring script
* `['dmon']['user']` - user who runes the monitoring script
* `['dmon']['git_url']` - git url of dmon
* `['dmon']['install_dir']` - installation directory of dmon monitoring
* `['dmon']['port']` - port of dmon-controller
* `['dmon']['ip']` - ip of dmon-controller
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
* `['dmon']['ls']['core_heap']` - ram restriction
* `['dmon']['ls']['host_FQDN']` - fully qualified domain name of Logstash host
* `['dmon']['ls']['ip']` - ip of the Logstash host
* `['dmon']['ls']['l_port']` - lumberjack port of Logstash
* `['dmon']['ls']['g_port']` - graphite port of Logstash
* `['dmon']['ls']['udp_port']` - udp port of Logstash
