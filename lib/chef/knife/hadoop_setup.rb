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
    class HadoopSetup < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop setup (options)"

      option :type,
        :short => "-T TYPE",
        :long => "--setup-type SETUP TYPE",
        :description => "The setup type <db,cluster>",
        :proc => Proc.new { |f| Chef::Config[:knife][:type] = f }
      

      option :table,
        :short => "-X TABLE",
        :long => "--database-table TABLE",
        :description => "The database table to be created",
        :proc => Proc.new { |f| Chef::Config[:knife][:table] = f }

      def run
        $stdout.sync = true
    
        type = "#{Chef::Config[:knife][:type]}".downcase
        case type
        when 'db'
          ui.methods
          db_connection.create_table "#{Chef::Config[:knife][:table]}" do
             String :directory
             String :accessTime
             String :blockSize
             String :group
             String :length
             String :modificationTime
             String :owner
             String :pathSuffix
             String :permission
             String :replication
             String :type
             DateTime :created_at      
          end          
        end
      end
    end
  end
end

