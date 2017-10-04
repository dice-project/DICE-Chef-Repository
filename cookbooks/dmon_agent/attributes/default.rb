# General attributes
default['dmon_agent']['install_dir'] = '/opt/dmon-agent'
default['dmon_agent']['tarball'] =
  'https://github.com/xlab-si/DICE-Monitoring/releases/download/v0.2.6x/'\
  'dice-monitoring-0.2.6x.tar.gz'
default['dmon_agent']['checksum'] =
  '84a5cedb689f778d146ff044295d00522cf7ed88196814058b4d309a906e8396'

# Apache Spark related attributes
default['dmon_agent']['spark']['graphite']['period'] = 5

# Mongo
default['dmon_agent']['mongodb']['dmon_user'] = 'dmon'

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
