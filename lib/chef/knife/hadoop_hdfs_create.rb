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
      
      option :data,
        :short => "-D DATA",
        :long => "--data DATA",
        :description => "The data to be populated into a file",
        :proc => Proc.new { |f| Chef::Config[:knife][:data] = f }

      option :path,
        :short => "-P PATH",
        :long => "--path PATH",
        :description => "The HDFS path - Directory or File to create",
        :proc => Proc.new { |f| Chef::Config[:knife][:path] = f }

      option :overwrite,
        :short => "-O OVERWRITE",
        :long => "--overwrite OVERWRITE",
        :description => "The overwrite bolean <true,fale>",
        :proc => Proc.new { |f| Chef::Config[:knife][:overwrite] = f }

      option :blocksize,
        :short => "-B BLOCKSIZE",
        :long => "--blocksize BLOCKSIZE",
        :description => "The blocksize",
        :proc => Proc.new { |f| Chef::Config[:knife][:blocksize] = f }

      option :replication,
        :short => "-R REPLICATION",
        :long => "--replication REPLICATION",
        :description => "The replication factor <n>",
        :proc => Proc.new { |f| Chef::Config[:knife][:replication] = f }

      option :permission,
        :short => "-P PERM",
        :long => "--permission PERMISSION",
        :description => "The permissions of the directory",
        :proc => Proc.new { |f| Chef::Config[:knife][:permission] = f }


      def run
        $stdout.sync = true
      
        type = "#{Chef::Config[:knife][:type]}".downcase
        case type
        when 'dir'
          hdfs_connection.mkdir("#{Chef::Config[:knife][:path]}", :permission => "#{Chef::Config[:knife][:permission]}")
        when 'file'
          ; debugger
          hdfs_connection.create("#{Chef::Config[:knife][:path]}", "#{Chef::Config[:knife][:data]}",
                                 :overwrite => "#{Chef::Config[:knife][:overwrite]}", :blocksize => "#{Chef::Config[:knife][:blocksize]}",
                                 :replication => "#{Chef::Config[:knife][:replication]}", :permission => "#{Chef::Config[:knife][:permission]}"
                                 )
        else
          ui.error ("Incorrect options. Please use --help to list options.")
        end
      end
    end
  end
end

