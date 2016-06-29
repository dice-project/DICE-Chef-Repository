#
# Cookbook Name:: storm
# Recipe:: start_supervisor
#
# Copyright 2015, XLAB d.o.o.
#
# All rights reserved - Do Not Redistribute
#
# This recipe should be called when the application is being
# configured, i.e., when the related components (zookeeper,
# any other Storm nodes) have been created, but not yet connected.

service 'storm-supervisor' do
  supports :status => true, :restart => true
  provider Chef::Provider::Service::Upstart if node['platform'] == 'ubuntu'
  action :start
end
