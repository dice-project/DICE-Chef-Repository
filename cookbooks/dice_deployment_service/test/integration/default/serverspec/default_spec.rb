require 'spec_helper'

# Host settings
describe file('/etc/hosts') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) do
    should include "#{host_inventory['hostname']}.node.consul"
  end
end

# Consul
describe group('consul') do
  it { should exist }
end

describe user('consul') do
  it { should exist }
  it { should belong_to_primary_group 'consul' }
end

describe file('/var/lib/consul') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'consul' }
end

describe service('consul-server') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8300) do
  it { should be_listening.with('tcp') }
end

describe port(8301) do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('udp') }
end

describe port(8302) do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('udp') }
end

# DNSmasq
describe service('dnsmasq') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/dnsmasq.conf') do
  its(:content) { should contain 'server=/consul/127.0.0.1#8600' }
end

describe port(53) do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('udp') }
end

# Main application
describe file('/var/lib/dice-deployment-service/dds') do
  it { should be_directory }
  it { should be_owned_by 'dice' }
  it { should be_grouped_into 'dice' }
end

# uWSGI
describe service('uwsgi') do
  it { should be_enabled }
  it { should be_running }
end

# Celery
describe service('celery') do
  it { should be_enabled }
  it { should be_running }
end

# Flower
describe service('flower') do
  it { should be_enabled }
  it { should be_running }
end

describe port(5555) do
  it { should be_listening.with('tcp') }
end

# nginx
describe file('/etc/nginx/sites-available/dice-deployment-service') do
  its(:content) do
    should include 'client_max_body_size 100m;'
  end
end
