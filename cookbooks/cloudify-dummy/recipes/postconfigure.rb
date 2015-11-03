#
# Cookbook Name:: cloudify-dummy
# Recipe:: postconfigure
#
# Copyright 2015, XLAB d.o.o.
#
# All rights reserved - Do Not Redistribute
#

# Use this recipe for the interface which does something 
# in the postconfigure interface.

application_directory = node["cloudify-dummy"]["application-path"]
configuration_server = "#{application_directory}/#{node["cloudify-dummy"]["server-config-file"]}"
configuration_client = "#{application_directory}/#{node["cloudify-dummy"]["client-config-file"]}"

directory application_directory do 
	action :create
end

file "#{application_directory}/dump.txt" do
	content "Testni izpis"
	mode '0755'
	action :create
end

template configuration_server do
	source 'config.erb'
	action :create
	variables :config => {
		'node_id' => node["cloudify"]["node_id"],
		'servers' => [ node["cloudify"]["related"]["ipaddress"] ]
	}
end

log "blueprint id: #{node["cloudify"]["blueprint_id"]}"
log "my IP: #{node["ipaddress"]}"
log "related node's IP: #{node["cloudify"]["related"]["runtime_properties"]["chef_attributes"]["ipaddress"]}"
log "my node id: #{node["cloudify"]["node_id"]}"
log "related node's id: #{node["cloudify"]["related"]["node_id"]}"
