require 'serverspec'
set :backend, :exec

describe group('jenkins') do
	it { should exist }
end

describe user('jenkins') do
	it { should exist }
end

describe package('jenkins') do
	it { should be_installed }
end

describe port(8080) do
	it { should be_listening.with('tcp6') }
end

describe file('/var/lib/jenkins/plugins') do
	it { should exist }
	it { should be_directory }
	it { should be_mode 755 }
	it { should be_owned_by 'jenkins' }
	it { should be_grouped_into 'jenkins' }
end

describe file('/var/lib/jenkins/plugins/dice-qt.hpi') do
	it { should exist }
end
