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
    class HadoopHdfsList < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop hdfs discover (options)"
      
      option :dir,
        :short => "-D DIR",
        :long => "--directory DIRECTORY",
        :description => "The HDFS directory",
        :proc => Proc.new { |f| Chef::Config[:knife][:dir] = f }

      def run
        $stdout.sync = true
        
        def file_system_directory_hash(path, name=nil)
          data = {:data => (name || path)}
          data[:children] = children = []
          Dir.foreach(path) do |entry|
            next if (entry == '..' || entry == '.')
            full_path = File.join(path, entry)
            if File.directory?(full_path)
              children << directory_hash(full_path, entry)
            else
              children << entry
            end
          end
          return data
        end
        
        def hdfs_directory_hash(path, name=nil) 
          data = {:data => (name || path)}
          data[:children] = children = []
          hdfs_layout = hdfs_connection.list(path)
          hdfs_layout.each do |item|
            item.each do |k, v|
              next if ("#{k}" == 'type' and item['type'] == 'DIRECTORY')
                full_path= File.join(path, "#{item['pathSuffix']}")
              if full_path
                children << hdfs_directory_hash(full_path, "#{item['pathSuffix']}")
              else
                children << "#{item['pathSuffix']}"
              end
            end
          end
          return data
        end
      
      end
    end
  end
end

