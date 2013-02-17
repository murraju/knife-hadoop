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
    class HadoopHdfsCreate < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop hdfs create (options)"

      option :type,
        :short => "-T TYPE",
        :long => "--type TYPE",
        :description => "The type <dir,file>",
        :proc => Proc.new { |f| Chef::Config[:knife][:type] = f }      
      
      option :dir,
        :short => "-D DIR",
        :long => "--directory DIRECTORY",
        :description => "The HDFS directory",
        :proc => Proc.new { |f| Chef::Config[:knife][:dir] = f }

      option :perm,
        :short => "-P PERM",
        :long => "--permission PERMISSION",
        :description => "The permissions of the directory",
        :proc => Proc.new { |f| Chef::Config[:knife][:perm] = f }


      def run
        $stdout.sync = true
      
        type = "#{Chef::Config[:knife][:type]}".downcase
        case type
        when 'dir'
          hdfs_connection.mkdir("#{Chef::Config[:knife][:dir]}", :permission => "#{Chef::Config[:knife][:perm]}")
        else
          ui.error ("Incorrect options. Please use --help to list options.")
        end
      end
    end
  end
end

