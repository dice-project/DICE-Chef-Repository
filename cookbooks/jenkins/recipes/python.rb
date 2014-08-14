#
# Cookbook Name:: jenkins
# Recipe:: python
#
# Author: Matej Artač <matej.artac@xlab.si>
#
# Copyright 2014, XLAB d.o.o.
#
# Do not reproduce.
#

['python', 'python-pip', 'libpython-dev'].each do |pkg|
	package pkg do
	end
end

bash 'setup virtualenvwrapper' do
	code 'pip install virtualenvwrapper'
	
	action :run
end

file '/var/lib/jenkins/.bashrc' do
	action :create_if_missing
end

ruby_block 'virtualenv parameters' do
	block do
		f = Chef::Util::FileEdit.new("/var/lib/jenkins/.bashrc")
		
		f.insert_line_if_no_match(/WORKON_HOME/,
				'export WORKON_HOME=$HOME/.virtualenvs')
		f.insert_line_if_no_match(/virtualenvwrapper_lazy/,
				'source /usr/local/bin/virtualenvwrapper_lazy.sh')
		f.write_file
	end
end
