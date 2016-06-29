#
# Cookbook Name:: storm
# Recipe:: configure
#
# Copyright 2015, XLAB d.o.o.
#
# All rights reserved - Do Not Redistribute
#
# This recipe should be called when the application is being
# configured, i.e., when the related components (zookeeper,
# any other Storm nodes) have been created, but not yet connected.

require 'json'

storm_user = node['storm']['user']
storm_version = node['storm']['version']
install_dir = node['storm']['install_dir']

storm_yaml = node['storm']['storm_yaml'].to_hash.dup
if node.key?('cloudify')
  storm_yaml.merge!(node['cloudify']['properties']['configuration'])

  rt_props = node['cloudify']['runtime_properties']
  storm_yaml['storm.zookeeper.servers'] = rt_props['zookeeper_quorum']
  storm_yaml['nimbus.seeds'] = if rt_props.key?('storm_nimbus_ip')
                                 [rt_props['storm_nimbus_ip']]
                               else
                                 [node['ipaddress']]
                               end
end

template "#{install_dir}/#{storm_version}/conf/storm.yaml" do
  source 'storm.yaml.erb'
  mode '0644'
  owner storm_user
  group storm_user
  variables(
    'storm_yaml' => JSON.parse(storm_yaml.to_json)
  )
end
