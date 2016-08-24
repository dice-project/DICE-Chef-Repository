#create if missing (for testing)
directory '/etc/spark' do
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
  not_if { File.directory?("/etc/spark") }
end

#upload spark metrics properties
template '/etc/spark/metrics.properties' do
  source 'spark-metrics.tmp.erb'
  owner "#{node['dmon_agent']['user']}"
  group "#{node['dmon_agent']['group']}"
  action :create
end
