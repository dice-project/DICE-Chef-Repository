#
# Cookbook Name:: dice-h2020
# Recipe:: conf-optim
#
# Copyright 2016, XLAB d.o.o.
#
# Apache 2 license
#

# Install dependencies
required_packages = ['unzip', 'python', 'python-virtualenv', 'python-dev']

required_packages.each do |pkg|
	package pkg do
		action :install
	end
end

install_path = node["dice-h2020"]["deployment-service"]["tools-install-path"]
directory 'install-dir' do
	path install_path
	action :create
end

remote_file '/tmp/deployment-service.zip' do
	source node["dice-h2020"]["deployment-service"]["release-url"]
	action :create_if_missing
end

bash 'install-ds-tools' do
	cwd "/tmp"	
	code <<-EOH
		[[ -d deployment-service ]] && rm -rf deployment-service
		mkdir -p deployment-service
		cd deployment-service
		unzip -q -u ../deployment-service.zip

		cd $(ls)

		cp tools/requirements.txt ../
		
		cp tools/dice-deploy-cli #{install_path}
		cp tools/extract-blueprint-parameters.py #{install_path}
		cp tools/update-blueprint-parameters.py #{install_path}
		cp -r tools/config_tool #{install_path}
		EOH
	action :run
end

python_runtime '2'

pip_requirements '/tmp/deployment-service/requirements.txt'
