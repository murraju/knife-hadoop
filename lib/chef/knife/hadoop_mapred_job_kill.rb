# Author:: Murali Raju (<murali.raju@appliv.com>)
# Copyright:: Copyright (c) 2012 Murali Raju.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'chef/knife/hadoop_base'

class Chef
  class Knife
    class HadoopMapredJobKill < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop mapred job kill (options)"

      option :filter,
        :short => "-F FILTER",
        :long => "--filter FILTER",
        :description => "Kill Job by either <jobid,jobname>",
        :proc => Proc.new { |f| Chef::Config[:knife][:filter] = f }
      
      option :jobid,
        :short => "-J JOBID",
        :long => "--job-id JOBID",
        :description => "The MapReduce JobID",
        :proc => Proc.new { |f| Chef::Config[:knife][:jobid] = f }

      option :jobname,
        :short => "-N JOBNAME",
        :long => "--job-name JOBNAME",
        :description => "The MapReduce JobNAME",
        :proc => Proc.new { |f| Chef::Config[:knife][:jobname] = f }

      def run
        $stdout.sync = true

        Chef::Log.debug("username: #{Chef::Config[:knife][:mapred_mgmt_host]}")
        Chef::Log.debug("password: #{Chef::Config[:knife][:mapred_mgmt_port]}")

        filter = "#{Chef::Config[:knife][:filter]}".downcase
        case filter
        when 'id'
          RestClient.delete "http://#{Chef::Config[:knife][:mapred_mgmt_host]}:#{Chef::Config[:knife][:mapred_mgmt_port]}/job/kill/id/#{Chef::Config[:knife][:jobid]}"
        when 'name'
          RestClient.delete "http://#{Chef::Config[:knife][:mapred_mgmt_host]}:#{Chef::Config[:knife][:mapred_mgmt_port]}/job/kill/name/#{Chef::Config[:knife][:jobname]}"
        end
      end
    end
  end
end

