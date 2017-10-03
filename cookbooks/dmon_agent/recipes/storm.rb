# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_install_dir = node['dmon_agent']['install_dir']
# TODO what if the storm recipe changes this path?
storm_log_dir = '/var/log/upstart'

template '/etc/default/dmon-agent.d/storm' do
  source 'service-vars.erb'
  variables env_vars: {
    'STORM_LOG' => storm_log_dir
  }
end

set_role 'storm' do
  dmon node['cloudify']['properties']['monitoring']['dmon_address']
  hostname node['hostname']
end
