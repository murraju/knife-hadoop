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
        
        hdfs_list = [
          ui.color('Directory',        :bold),
          ui.color('accessTime',       :bold),
          ui.color('blockSize',        :bold),
          ui.color('group',            :bold),
          ui.color('length',           :bold),
          ui.color('modificationTime', :bold),
          ui.color('owner',            :bold),
          ui.color('pathSuffix',       :bold),
          ui.color('permission',       :bold),
          ui.color('replication',      :bold),
          ui.color('type',             :bold)
        ]
        
        type = "#{Chef::Config[:knife][:type]}".downcase
        case type
        when 'summary'
          Net::SSH.start( "#{Chef::Config[:knife][:namenode_host]}", 
                          "#{Chef::Config[:knife][:ssh_user]}", :password => "#{Chef::Config[:knife][:ssh_password]}" ) do|ssh|
            result = ssh.exec!('hadoop dfsadmin -report')
            puts ''
            puts result.match(/Configured Capacity: \d+(.*?) .*/)
            puts result.match(/Present Capacity: \d+(.*?) .*/)
            puts result.match(/DFS Remaining: \d+(.*?) .*/)
            puts result.match(/DFS Used: \d+(.*?) .*/)
            puts result.match(/DFS Used%: \d+(.*?).*/)
            puts result.match(/Under replicated blocks: \d+(.*?)/)
            puts result.match(/Blocks with corrupt replicas: \d+(.*?)/)
            puts result.match(/Missing blocks: \d+(.*?)/)
            puts result.match(/Datanodes available: \d+(.*?)/)
            puts ''
          end
        end
        

        #puts ui.list(hdfs_list, :uneven_columns_across, 11)
      end
    end
  end
end
