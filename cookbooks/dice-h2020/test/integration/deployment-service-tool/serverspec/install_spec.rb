require 'serverspec'

set :backend, :exec

describe "Deployment Service tools installed" do
	dep_packages = ['unzip', 'python', 'python-virtualenv', 'python-dev']
	dep_packages.each do |pkg|
		describe package(pkg) do
			it { should be_installed }
		end
	end
	dirs_expected = ['/usr/share/deployment-service', '/usr/share/deployment-service/config_tool']
	dirs_expected.each do |dir|
		describe file(dir) do
			it { should be_directory }
			it { should be_owned_by 'root' }
			it { should be_grouped_into 'root' }
			it { should be_mode 755 }
		end
	end
	files_expected = ['/tmp/deployment-service.tar.gz',
		'/usr/share/deployment-service/config_tool/utils.py']
	files_expected.each do |file|
		describe file(file) do
			it { should be_file }
			it { should be_owned_by 'root' }
			it { should be_grouped_into 'root' }
			it { should be_mode 644 }
		end
	end
	execs_expected = ['/usr/share/deployment-service/dice-deploy-cli',
		'/usr/share/deployment-service/extract-blueprint-parameters.py',
		'/usr/share/deployment-service/update-blueprint-parameters.py']
	execs_expected.each do |exec|
		describe file(exec) do
			it { should be_file }
			it { should be_owned_by 'root' }
			it { should be_grouped_into 'root' }
			it { should be_mode 755 }
		end
	end
	describe file('/usr/bin/dice-deploy-cli') do
		it { should be_file }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'root' }
	end
	describe command('cd /usr/share/deployment-service && python update-blueprint-parameters.py -h') do
		its(:exit_status) { should eq 0 }
	end
	describe command('cd /usr/share/deployment-service && python extract-blueprint-parameters.py -h') do
		its(:exit_status) { should eq 0 }
	end
	describe command('/usr/bin/dice-deploy-cli -h') do
		its(:exit_status) { should eq 0 }
	end
end