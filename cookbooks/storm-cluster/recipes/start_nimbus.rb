#
# Cookbook Name:: storm
# Recipe:: start_nimbus
#
# Copyright 2015, XLAB d.o.o.
#
# All rights reserved - Do Not Redistribute
#
# This recipe should be called when the application is being
# configured, i.e., when the related components (zookeeper,
# any other Storm nodes) have been created, but not yet connected.

service 'storm-nimbus' do
  supports :status => true, :restart => true
  provider Chef::Provider::Service::Upstart if node['platform'] == 'ubuntu'
  action :start
end

service 'storm-ui' do
  supports :status => true, :restart => true
  provider Chef::Provider::Service::Upstart if node['platform'] == 'ubuntu'
  action :start
end
