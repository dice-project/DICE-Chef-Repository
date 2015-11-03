#
# Cookbook Name:: cloudify-dummy
# Recipe:: install
#
# Copyright 2015, XLAB d.o.o.
#
# All rights reserved - Do Not Redistribute
#

# Use this recipe for the interface which installs or configures
# the node.

application_directory = node["cloudify-dummy"]["application-path"]
configuration_server = "#{application_directory}/#{node["cloudify-dummy"]["server-config-file"]}"
configuration_client = "#{application_directory}/#{node["cloudify-dummy"]["client-config-file"]}"

directory application_directory do 
	action :create
end

template configuration_server do
	source 'config.erb'
	action :create
	variables :config => {
		'node_id' => node["cloudify"]["node_id"],
		'servers' => { }
	}
end
