# General attributes
default['dmon_agent']['install_dir'] = '/opt/dmon-agent'
default['dmon_agent']['tarball'] =
  'https://github.com/dice-project/DICE-Monitoring/archive/v0.2.3.tar.gz'
default['dmon_agent']['checksum'] =
  '1d7b6ced81dd19259a69d1620f0eb0c17992102623d8ea7c731391912cfeb43e'

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
