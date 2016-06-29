default['storm']['version'] = '1.0.1'
default['storm']['package'] = "apache-storm-#{node['storm']['version']}"
default['storm']['install_dir'] = '/usr/share/storm'
default['storm']['user'] = 'storm'

default['storm']['install_method'] = 'remote_file'

default['storm']['download_url'] = 'http://www.apache.si/storm'
default['storm']['download_dir'] = "/#{node['storm']['package']}/#{node['storm']['package']}.tar.gz"
