dmon_agent Cookbook
============

This cookbook installs dmon_agent for collecting system and big data services data from the node.

Attributes
----------

### General
* `['dmon_agent']['group']` - group of the user who runes dmon_agent
* `['dmon_agent']['user']` - user who runes dmon_agent
* `['dmon_agent']['home_dir']` - directory of dmon_agent installation
* `['dmon_agent']['git_url']` - git url of dmon_agent release (.tar.gz file)

### Logstash 
* `['dmon_agent']['logstash']['ip']` - ip of the Logstash service
* `['dmon_agent']['logstash']['udp_port']` - udp port of the Logstash service
* `['dmon_agent']['logstash']['l_port']` - lumberjack port of the Logstash service
* `['dmon_agent']['logstash']['lsf_crt']` - Logstash-forwarder certificate which is created on Logstash installation on dmon (/opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt)

