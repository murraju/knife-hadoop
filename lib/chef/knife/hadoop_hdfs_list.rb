# Author:: Murali Raju (<murali.raju@appliv.com>)
# Author:: Velankani Engineering <eng@velankani.net>
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
    class HadoopHdfsList < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop hdfs list (directory)"
      
      option :dir,
        :short => "-D DIR",
        :long => "--directory DIRECTORY",
        :description => "The HDFS directory",
        :proc => Proc.new { |f| Chef::Config[:knife][:dir] = f }

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
        
        #There has to be a more elegant way to do the below iteration :-)

        hdfs_layout = hdfs_connection.list("#{Chef::Config[:knife][:dir]}") 
        hdfs_layout.each do |item|
          hdfs_list << "#{Chef::Config[:knife][:dir]}"
          item.each do |k, v|
            if "#{k}" == 'accessTime'
               hdfs_list << item['accessTime'].to_s
            elsif "#{k}" == 'blockSize'
               hdfs_list << item['blockSize'].to_s
            elsif "#{k}" == 'group'
               hdfs_list << item['group'].to_s
            elsif "#{k}" == 'length'
               hdfs_list << item['length'].to_s
            elsif "#{k}" == 'modificationTime'
               hdfs_list << item['modificationTime'].to_s
            elsif "#{k}" == 'owner'
               hdfs_list << item['owner'].to_s
            elsif "#{k}" == 'pathSuffix'
               hdfs_list << item['pathSuffix'].to_s
            elsif "#{k}" == 'permission'
               hdfs_list << item['permission'].to_s
            elsif "#{k}" == 'replication'
               hdfs_list << item['replication'].to_s
            elsif "#{k}" == 'type'
               hdfs_list << item['type'].to_s
            else
              ui.error ("WebHDFS is not responding. Please debug")
            end
          end 
        end
        puts ui.list(hdfs_list, :uneven_columns_across, 11)
      end
    end
  end
end

