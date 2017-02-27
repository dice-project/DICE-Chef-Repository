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