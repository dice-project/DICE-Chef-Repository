execute 'http server' do
  command "while true; do { echo 'HTTP/1.1 200 OK\r\n'; } | nc -l 5001; done >dmon.log &"
  cwd "/var/log"
end
