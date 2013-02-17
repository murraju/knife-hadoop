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
    class HadoopHdfsSnapshot < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop hdfs snapshot (options)"
      
      option :dir,
        :short => "-D DIR",
        :long => "--directory DIRECTORY",
        :description => "The HDFS directory",
        :proc => Proc.new { |f| Chef::Config[:knife][:dir] = f }

      option :table,
        :short => "-X TABLE",
        :long => "--database-table TABLE",
        :description => "The database table to be used",
        :proc => Proc.new { |f| Chef::Config[:knife][:table] = f }

      def run
        $stdout.sync = true
        dataset = db_connection.from("#{Chef::Config[:knife][:table]}")
        list = hdfs_connection.list("#{Chef::Config[:knife][:dir]}")
        list.each do |item|
          item.each do |k, v|
            if "#{k}" == 'accessTime'
              @accessTime = item['accessTime']
            elsif "#{k}" == 'blockSize'
              @blockSize = item['blockSize']
            elsif "#{k}" == 'group'
              @group = item['group']
            elsif "#{k}" == 'length'
              @length = item['length']
            elsif "#{k}" == 'modificationTime'
              @modificationTime = item['modificationTime']
            elsif "#{k}" == 'owner'
              @owner = item['owner']
            elsif "#{k}" == 'pathSuffix'
              @pathSuffix = item['pathSuffix']
            elsif "#{k}" == 'permission'
              @permission = item['permission']
            elsif "#{k}" == 'replication'
              @replication = item['replication']
            elsif "#{k}" == 'type'
              @type = item['type']
            else
              puts "Cannot read key value pairs. Please debug"
            end
          end

          db_connection.transaction do
                dataset.insert(
                  :directory => "#{Chef::Config[:knife][:dir]}",
                  :accessTime => "#{@accessTime}",
                  :blockSize =>  "#{@blockSize}",
                  :group =>  "#{@group}",
                  :length =>  "#{@length}",
                  :modificationTime =>  "#{@modificationTime}",
                  :owner =>  "#{@owner}",
                  :pathSuffix =>  "#{@pathSuffix}",
                  :permission =>  "#{@permission}",
                  :replication => "#{@replication}",
                  :type =>  "#{@type}",
                  :created_at => Time.now
                  ) 
          end       
        end        
      end
    end
  end
end

