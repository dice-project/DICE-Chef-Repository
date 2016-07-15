require 'serverspec'

set :backend, :exec

describe 'Matlab install archive' do
	describe file('/tmp/matlab/install') do
		it { should be_file }
	end
	describe file('/tmp/matlab/MCR_license.txt') do
		it { should be_file }
	end
end

describe 'Matlab installation' do
	describe file('/opt/matlab') do
		it { should be_directory }
	end
	describe file('/opt/matlab/v85') do
		it { should be_directory }
	end
	describe file('/opt/matlab/v85/bin/glnxa64/matlab_helper') do
		it { should be_file }
	end
end

describe 'Requirements installed' do
	dep_packages = ['g++', 'libxmu6', 'libxt6', 'libxpm4', 'libxp6' ]
	dep_packages += ['python', 'python-virtualenv', 'python-dev']
	dep_packages.each do |pkg|
		describe package(pkg) do
			it { should be_installed }
		end
	end
end

describe "Configuration Optimization installed" do
	dirs_expected = ['/opt/co', '/opt/co/conf']
	dirs_expected.each do |dir|
		describe file(dir) do
			it { should be_directory }
		end
	end
	files_expected = ['/opt/co/main', '/opt/co/run_main.sh',
		'/opt/co/merge_expconfig.py' ]
	files_expected.each do |file|
		describe file(file) do
			it { should be_file }
		end
	end
	describe file('/opt/co/run_bo4co.sh') do
		it { should be_file }
		it { should be_executable.by('owner') }
		it { should be_executable.by('group') }
		it { should be_executable.by('others') }
		its(:content) { should match(/cd \/opt\/co/) }
		its(:content) { should match(/run_main.sh \/opt\/matlab\/v85\//) }
	end
	describe file('/opt/co/conf/config.yaml') do
		it { should be_file }
		its (:content) { should match(/confFolder: .\/integrated\/config\//) }
		its (:content) { should match(/URL: http:\/\/10.10.50.3:8000/) }
		its (:content) { should match(/URL: http:\/\/10.10.50.20:5001/) }
		its (:content) { should match(/username: admin/) }
		its (:content) { should match(/password: LetJustMeIn/) }
	end
	describe command('python -c "import yaml"') do
		its(:stderr) { should_not match /ImportError/ }
		its(:exit_status) { should eq 0 }
	end
end
