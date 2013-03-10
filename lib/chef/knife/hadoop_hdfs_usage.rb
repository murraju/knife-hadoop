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
    class HadoopHdfsUsage < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        require 'net/ssh'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop hdfs usage (options)"
      
      option :type,
        :short => "-T TYPE",
        :long => "--type TYPE",
        :description => "The type <summary,detail>",
        :proc => Proc.new { |f| Chef::Config[:knife][:type] = f }

      option :ssh_user,
        :short => "-U SSHUSER",
        :long => "--ssh-user SSHUSER",
        :description => "The SSH User",
        :proc => Proc.new { |f| Chef::Config[:knife][:ssh_user] = f }

        option :ssh_password,
          :short => "-P SSHPASSWORD",
          :long => "--ssh-password SSHPASSWORD",
          :description => "The SSH User Password",
          :proc => Proc.new { |f| Chef::Config[:knife][:ssh_password] = f }

      def run
        $stdout.sync = true
        
        hdfs_usage_summary_list = [
          ui.color('Configured Capacity',           :bold),
          ui.color('Present Capacity',              :bold),
          ui.color('DFS Remaining',                 :bold),
          ui.color('DFS Used',                      :bold),
          ui.color('DFS Used%',                     :bold),
          ui.color('Under replicated blocks',       :bold),
          ui.color('Blocks with corrupt replicas',  :bold),
          ui.color('Missing blocks',                :bold),
          ui.color('Datanodes available',           :bold)
        ]

        hdfs_usage_node_list = [
          ui.color('Data Node',                     :bold),
          ui.color('Decommission Status',           :bold),
          ui.color('Configured Capacity',           :bold),
          ui.color('DFS Used',                      :bold),
          ui.color('Non DFS Used',                  :bold),
          ui.color('DFS Remaining',                 :bold),
          ui.color('DFS Used%',                     :bold),
          ui.color('DFS Remaining%',                :bold),
          ui.color('Last contact',                  :bold)
        ]        
        
        type = "#{Chef::Config[:knife][:type]}".downcase
        case type
        when 'summary'
          Net::SSH.start( "#{Chef::Config[:knife][:namenode_host]}", 
                          "#{Chef::Config[:knife][:ssh_user]}", :password => "#{Chef::Config[:knife][:ssh_password]}" ) do|ssh|
            result = ssh.exec!('hadoop dfsadmin -report')
            hdfs_usage_summary_list << result.match(/Configured Capacity: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/Present Capacity: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/DFS Remaining: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/DFS Used: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/DFS Used%: \d+(.*?).*/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/Under replicated blocks: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/Blocks with corrupt replicas: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/Missing blocks: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_summary_list << result.match(/Datanodes available: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
          end
          puts ui.list(hdfs_usage_summary_list, :uneven_columns_across, 9)
        when 'detail'
          Net::SSH.start( "#{Chef::Config[:knife][:namenode_host]}", 
                          "#{Chef::Config[:knife][:ssh_user]}", :password => "#{Chef::Config[:knife][:ssh_password]}" ) do|ssh|
            result = ssh.exec!('hadoop dfsadmin -report')
            hdfs_usage_node_list << result.match(/Name: \d+(.*?).*/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/Decommission Status : \w+(.*?).*/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/Configured Capacity: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/DFS Used: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/Non DFS Used: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/DFS Remaining: \d+(.*?)/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/DFS Used%: \d+(.*?).*/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/DFS Remaining%: \d+(.*?).*/).to_s.split(':')[1].gsub(/\s+/, "")
            hdfs_usage_node_list << result.match(/Last contact: \w+(.*?) .*/).to_s.split(':')[1] 
          end
          puts ui.list(hdfs_usage_node_list, :uneven_columns_across, 9)
        end  
      end
    end
  end
end
