dmon_agent Cookbook
============

This cookbook installs dmon_agent from 
https://github.com/igabriel85/IeAT-DICE-Repository/tree/master/dmon-agent.
It's a microservice designed to provide control over different metrics 
collection components. In the current version these include Collectd and 
Logstash-forwarder. Those programs are installed according to the big data 
system (role) that you choose.

## Cookbook requirements

- apt
- dice-common
- poise-python


## Recipes

- `dmon_agent::default` - installs dmon_agent registers the node on dmon
- `dmon_agent::mock_dmon` - runs mock http server for testing http_request
- `dmon_agent::collectd` - installs Collectd (running dice-common::host before 
this is required)
- `dmon_agent::lsf` - installs Logstash-forwarder
- `dmon_agent::storm` - sets node role (storm) on dmon
- `dmon_agent::spark` - configure spark (run after spark installation) and sets 
node role (spark) on dmon


# Roles

### Storm

Use run list:
```
- recipe[apt::default]
- recipe[dice-common::host]
- recipe[dmon_agent::default]
- recipe[dmon_agent::collectd]
- recipe[dmon_agent::storm]
```

Only Collectd is installed for system data collection. Dmon gets all additional 
information form the Storm REST API.

### Spark

Use run list:
```
- recipe[apt::default]
- recipe[dice-common::host]
- recipe[dmon_agent::default]
- recipe[dmon_agent::collectd]
- recipe[dmon_agent::spark]
```

Collectd is installed for system data collection. Additionally a 
`matrics.properties` file is configured so that spark himself is sending data to 
dmon.


# Attributes

### General
* `['dmon_agent']['group']` - group of the user who runs dmon_agent
* `['dmon_agent']['user']` - user who runs dmon_agent
* `['dmon_agent']['home_dir']` - directory of dmon_agent installation
* `['dmon_agent']['tarball']` - tar url of dmon_agent release
* `['dmon_agent']['node_ip']` - ip of dmon_agent - for testing only

### Dmon
* `['dmon_agent']['dmon']['ip']` - ip of dmon
* `['dmon_agent']['dmon']['port']` - port of dmon

### Logstash 
* `['dmon_agent']['logstash']['ip']` - ip of Logstash
* `['dmon_agent']['logstash']['udp_port']` - udp port of Logstash
* `['dmon_agent']['logstash']['l_port']` - lumberjack port of Logstash
* `['dmon_agent']['logstash']['g_port']` - graphite port of Logstash
* `['dmon_agent']['logstash']['period']` - period (s) of data collection
* `['dmon_agent']['logstash']['lsf_crt']` - Logstash-forwarder certificate which
is created on Logstash installation on dmon
