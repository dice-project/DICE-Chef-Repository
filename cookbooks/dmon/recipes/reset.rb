# stop dmon
service "dmon" do
  action :stop
end

execute 'kill' do
  command "kill -9 $(cat #{node['dmon']['install_dir']}/src/pid/logstash.pid)"
end
  
file "#{node['dmon']['install_dir']}/src/pid/logstash.pid" do
  action :delete
end

# empty db
tables = ['db_es_core', 'db_kb_core', 'db_nodes', 'db_s_core']

tables.each do |t|
  execute 'empty' do
    command "sqlite3 dmon.db \"delete from #{t};\""
    cwd "#{node['dmon']['install_dir']}/src/db"
  end
end

# stop dmon
service "dmon" do
  action :start
end

