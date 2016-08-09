dmon_agent Cookbook
============

This cookbook installs dmon_agent from https://github.com/igabriel85/IeAT-DICE-Repository/tree/master/dmon-agent.
It also installs Collectd for system data collection and Logstash-forwarder for 
logs collection from big data services.
Both services are then configured for sending their data to dmon.

Requirements
------------

For running Logstash-forwarder the lumberjack port on Logstash must be enabled. 
One can do this by adding a node with the 'yarn' role (more on https://github.com/igabriel85/IeAT-DICE-Repository/tree/master/src)
on dmon. You also need the certificate that is used for securing the lumberjack connection.
Its default location on dmon is /opt/IeAT-DICE-Repository/src/keys/logstash-forwarder.crt.


Attributes
----------

### General
* `['dmon_agent']['group']` - group of the user who runs dmon_agent
* `['dmon_agent']['user']` - user who runs dmon_agent
* `['dmon_agent']['home_dir']` - directory of dmon_agent installation
* `['dmon_agent']['git_url']` - git url of dmon_agent release (.tar.gz file)

### Logstash 
* `['dmon_agent']['logstash']['ip']` - ip of the Logstash service
* `['dmon_agent']['logstash']['udp_port']` - udp port of the Logstash service
* `['dmon_agent']['logstash']['l_port']` - lumberjack port of the Logstash service
* `['dmon_agent']['logstash']['lsf_crt']` - Logstash-forwarder certificate which
is created on Logstash installation on dmon
