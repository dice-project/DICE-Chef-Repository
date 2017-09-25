# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_install_dir = node['dmon_agent']['install_dir']
# TODO what if the storm recipe changes this path?
storm_log_dir = '/var/log/upstart'

# TODO not idempotent, becuase it overrides any other services'
#      custom configuration file
template '/etc/init/dmon-agent.conf' do
  source 'dmon-agent.conf.erb'
  variables(
    install_dir: dmon_install_dir,
    user: 'root',
    group: 'root',
    env_vars: {'STORM_LOG' => storm_log_dir}
  )
end

set_role 'storm' do
  dmon node['cloudify']['properties']['monitoring']['dmon_address']
  hostname node['hostname']
end
