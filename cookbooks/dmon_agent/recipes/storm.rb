# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

set_role 'storm' do
  dmon node['cloudify']['properties']['monitoring']['dmon_address']
  hostname node['hostname']
end
