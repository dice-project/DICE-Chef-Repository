#general attributes
default['dmon_agent']['group'] = 'dmon-agent'
default['dmon_agent']['user'] = 'dmon-agent'
default['dmon_agent']['home_dir'] = '/home/dmon-agent'
default['dmon_agent']['node_name'] = 'name'
default['dmon_agent']['tarball'] = 'https://github.com/igabriel85/IeAT-DICE-Repository/releases/download/v0.0.4-dmon-agent/dmon-agent.tar.gz'

#dmon related attributes
default['dmon_agent']['dmon']['ip'] = 'ip'
default['dmon_agent']['dmon']['port'] = 'port'

#attributes for service configuration
default['dmon_agent']['logstash']['ip'] = 'ip'
default['dmon_agent']['logstash']['udp_port'] = 'port'
default['dmon_agent']['logstash']['l_port'] = '5000'
default['dmon_agent']['logstash']['g_port'] = '5002'
default['dmon_agent']['logstash']['period'] = '5'
default['dmon_agent']['logstash']['lsf_crt'] = 'crt'
