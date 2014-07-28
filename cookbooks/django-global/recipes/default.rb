#
# Cookbook Name:: django-global
# Recipe:: default
#
# Copyright 2014, XLAB d.o.o.
#
# All rights reserved - Do Not Redistribute
#



execute "apt update" do
	command "apt-get update"
end

["python", "python-pip", "libpython-dev", "libmysqlclient-dev"].each do |pkg|
	apt_package pkg do
		action :install
	end
end

include_recipe 'python'

python_pip node[:django][:djangopip] do
	action :install
end
