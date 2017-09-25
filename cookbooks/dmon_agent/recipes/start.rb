# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

service 'dmon-agent' do
  action :restart
end
