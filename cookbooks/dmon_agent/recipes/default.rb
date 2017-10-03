# Sanity check
Chef::Recipe.send(:include, DmonAgent::Helper)
return if skip_installation?

dmon_master = node['cloudify']['properties']['monitoring']['dmon_address']
dmon_install_dir = node['dmon_agent']['install_dir']

# NOTE: There is no separate package for dmon agent at the moment and we
# actually download complete dmon repo. Just something to keep in mind.
dmon_tar = "#{Chef::Config[:file_cache_path]}/dmon.tar.gz"
remote_file dmon_tar do
  source node['dmon_agent']['tarball']
  checksum node['dmon_agent']['checksum']
  action :create
end

dmon_dir = "#{Chef::Config[:file_cache_path]}/dmon"
poise_archive dmon_tar do
  destination dmon_dir
end

# Ugly, but needed, because we have no proper agent package
bash 'Get agent subfolder' do
  code <<-EOH
    [[ -d #{dmon_install_dir} ]] || \
      mv -f #{dmon_dir}/dmon-agent #{dmon_install_dir}
    EOH
end

http_request 'Register node on DMon master' do
  action :put
  url "http://#{dmon_master}/dmon/v1/overlord/nodes"
  message({
    Nodes: [
      NodeName: node['hostname'],
      NodeIP: node['ipaddress'],
      NodeOS: node['platform'],
      key: nil,
      username: nil,
      password: nil
    ]
  }.to_json)
  headers 'Content-Type' => 'application/json'
end

roles = node['cloudify']['properties']['monitoring']['roles']
set_role 'Setting node role (ONLY FIRST ROLE)' do
  role roles.empty? ? '' : roles[0] # To satisfy strict checking in Chef 13
  dmon dmon_master
  hostname node['hostname']

  not_if { roles.empty? }
end

['log', 'cert'].each do |dir|
  directory("#{dmon_install_dir}/#{dir}") do
    action :create
  end
end

directory '/etc/default/dmon-agent.d' do
  action :create
end

template '/etc/init/dmon-agent.conf' do
  source 'dmon-agent.conf.erb'
  variables(
    install_dir: dmon_install_dir,
    user: 'root',
    group: 'root'
  )
end

python_runtime '2'

python_virtualenv "#{dmon_install_dir}/dmonEnv"

pip_requirements "#{dmon_install_dir}/requirements.txt"
