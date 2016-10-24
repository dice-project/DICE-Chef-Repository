# General attributes
default['dmon_agent']['group'] = 'dmon-agent'
default['dmon_agent']['user'] = 'dmon-agent'
default['dmon_agent']['home_dir'] = '/home/dmon-agent'
default['dmon_agent']['install_dir'] =
  "#{node['dmon_agent']['home_dir']}/dmon-agent"
default['dmon_agent']['tarball'] =
  'https://github.com/igabriel85/IeAT-DICE-Repository/releases/download/'\
  'v0.0.4-dmon-agent/dmon-agent.tar.gz'
default['dmon_agent']['checksum'] =
  'bb6c5e519bc3e0fb7865c4ae013bd1c826a769a40e212b8cf6488285c78e8322'

# Apache Spark related attributes
default['dmon_agent']['spark']['graphite']['period'] = 5

# Cloudify provided attributes
#
# node['cloudify']['properties']['monitoring'] contains the following keys:
#   * enabled: should monitoring infrastructure be installed on this node
#       (boolean, defalts to false)
#   * dmon_address: address of central dmon service
#       (address in "123.234.12.34:5432" format, defaults to INVALID_ADDRESS)
#   * logstash_lumberjack_address: lumberjack address
#       (address in "123.234.12.34:5432" format, defaults to INVALID_ADDRESS)
#   * logstash_lumberjack_crt: lumberjack certificate
#       (certificate string, defaults to INVALID_CRT)
#   * logstash_graphite_address: graphite address
#       (address in "123.234.12.34:5432" format, defaults to INVALID_ADDRESS)
#   * logstash_udp_address: udp address
#       (address in "123.234.12.34:5432" format, defaults to INVALID_ADDRESS)
