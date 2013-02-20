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
    class HadoopMapredJobList < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop mapred job list (options)"
      
      option :filter,
        :short => "-F FILTER",
        :long => "--filter FILTER",
        :description => "List MapReduce jobs <all,user>",
        :proc => Proc.new { |f| Chef::Config[:knife][:filter] = f }

      option :name,
        :short => "-N NAME",
        :long => "--name NAME",
        :description => "List by User Name",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      def run
        $stdout.sync = true

        Chef::Log.debug("username: #{Chef::Config[:knife][:mapred_mgmt_host]}")
        Chef::Log.debug("password: #{Chef::Config[:knife][:mapred_mgmt_port]}")

        job_list = [
          ui.color('jobid',           :bold),
          ui.color('mapComplete',     :bold),
          ui.color('name',            :bold),
          ui.color('priority',        :bold),
          ui.color('reduceComplete',  :bold),
          ui.color('schedulingInfo',  :bold),
          ui.color('startTime',       :bold),
          ui.color('state',           :bold),
          ui.color('user',            :bold)
        ]
        
        filter = "#{Chef::Config[:knife][:filter]}".downcase
        case filter
        when 'all'
          response = RestClient.get "http://#{Chef::Config[:knife][:mapred_mgmt_host]}:#{Chef::Config[:knife][:mapred_mgmt_port]}/job/list"
          collection = JSON.parse(response)
          collection.each do |item|
            job_list << item['jobid']
            job_list << item['mapComplete']
            job_list << item['name']
            job_list << item['priority']
            job_list << item['reduceComplete']
            job_list << item['schedulingInfo']
            job_list << item['startTime']
            job_list << item['state']
            job_list << item['user']
          end
        when 'user'
          response = RestClient.get "http://#{Chef::Config[:knife][:mapred_mgmt_host]}:#{Chef::Config[:knife][:mapred_mgmt_port]}/job/list"
          collection = JSON.parse(response)
          collection.each do |item|
           if "#{Chef::Config[:knife][:name]}" == item['user']
              job_list << item['jobid']
              job_list << item['mapComplete']
              job_list << item['name']
              job_list << item['priority']
              job_list << item['reduceComplete']
              job_list << item['schedulingInfo']
              job_list << item['startTime']
              job_list << item['state']
              job_list << item['user']
            end
          end
        end
        puts ui.list(job_list, :uneven_columns_across, 9)
      end
    end
  end
end

