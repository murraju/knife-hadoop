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
    class HadoopHdfsUpdate < Knife

      include Knife::HadoopBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife hadoop hdfs update (options)"
   
      
      option :path,
        :short => "-O ORIGINALPATH",
        :long => "--original-path ORIGINALPATH",
        :description => "The original HDFS path",
        :proc => Proc.new { |f| Chef::Config[:knife][:path] = f }

      option :newpath,
        :short => "-N NEWPATH",
        :long => "--new-path NEWPATH",
        :description => "The new HDFS path",
        :proc => Proc.new { |f| Chef::Config[:knife][:newpath] = f }


      def run
        $stdout.sync = true
      
        hdfs_connection.rename("#{Chef::Config[:knife][:path]}", 
                               "#{Chef::Config[:knife][:newpath]}")
      end
    end
  end
end

