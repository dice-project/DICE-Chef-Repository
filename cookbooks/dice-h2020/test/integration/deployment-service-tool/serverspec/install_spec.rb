require 'serverspec'

set :backend, :exec

describe "Deployment Service tools installed" do
	dep_packages = ['unzip', 'python', 'python-virtualenv', 'python-dev']
	dep_packages.each do |pkg|
		describe package(pkg) do
			it { should be_installed }
		end
	end
	dirs_expected = ['/opt/deployment-service', '/opt/deployment-service/config_tool']
	dirs_expected.each do |dir|
		describe file(dir) do
			it { should be_directory }
		end
	end
	files_expected = ['/tmp/deployment-service.zip',
		'/opt/deployment-service/dice-deploy-cli',
		'/opt/deployment-service/extract-blueprint-parameters.py',
		'/opt/deployment-service/update_blueprint_parameters.py',
		'/opt/deployment-service/config_tool/utils.py']
	files_expected.each do |file|
		describe file(file) do
			it { should be_file }
		end
	end
	describe command('cd /opt/deployment-service && python update_blueprint_parameters.py -h') do
		its(:exit_status) { should eq 0 }
	end
	describe command('cd /opt/deployment-service && python extract-blueprint-parameters.py -h') do
		its(:exit_status) { should eq 0 }
	end
end