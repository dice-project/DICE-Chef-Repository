# Cookbook Name:: cassandra
# Library:: helper
#
# Copyright 2016, XLAB d.o.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'timeout'
require 'open-uri'

module Cassandra
  # Module with helper functions for cassandra cookbook
  module Helper
    class CassandraTimeout < Timeout::Error; end

    # Simple class that informs user that Cassandra failed to start.
    class CassandraNotReady < StandardError
      def initialize
        super 'The Cassandra did not start in time.'
      end
    end

    def wait_for_cassandra
      Timeout.timeout(120, CassandraTimeout) do
        begin
          open("http://#{node['ipaddress']}:9042")
        rescue Net::HTTPBadResponse
          return
        rescue
          Chef::Log.info('Cassandra is not ready yet.')
          sleep(1)
          retry
        end
      end
    rescue CassandraTimeout
      raise CassandraNotReady
    end
  end
end
