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

require 'chef/knife'
require 'webhdfs'
require 'debugger'

class Chef
  class Knife
    module HadoopBase

      def self.included(includer)
        includer.class_eval do

          deps do
            require 'readline'
            require 'chef/json_compat'
          end

          option :namenode_username,
            :short => "-U USERNAME",
            :long => "--namenode-username USERNAME",
            :description => "NameNode Username",
            :proc => Proc.new { |key| Chef::Config[:knife][:namenode_username] = key }

          option :namenode_password,
            :short => "-P PASSWORD",
            :long => "--namenode-password PASSWORD",
            :description => "NameNode password",
            :proc => Proc.new { |key| Chef::Config[:knife][:namenode_password] = key }

          option :namenode_host,
            :short => "-H HOST",
            :long => "--namenode-host HOST",
            :description => "NameNode FQDN or IP address",
            :proc => Proc.new { |endpoint| Chef::Config[:knife][:namenode_host] = endpoint }

          option :namenode_port,
            :short => "-A PORT",
            :long => "--namenode-port PORT",
            :description => "NameNode port",
            :proc => Proc.new { |key| Chef::Config[:knife][:namenode_port] = key }
          
        end
      end

      def connection
        Chef::Log.debug("username: #{Chef::Config[:knife][:namenode_username]}")
        Chef::Log.debug("password: #{Chef::Config[:knife][:namenode_password]}")
        Chef::Log.debug("host:     #{Chef::Config[:knife][:namenode_host]}")
        Chef::Log.debug("port:     #{Chef::Config[:knife][:namenode_port]}")
        @connection ||= begin
          connection = WebHDFS::Client.new("#{Chef::Config[:knife][:namenode_host]}", 
                                           "#{Chef::Config[:knife][:namenode_port]}")
        end
      end
      
      #Intialize objects
      # def inventory
      #   ucs_inventory = UCSInventory.new
      #   @inventory ||= begin
      #     inventory = ucs_inventory.discover(connection)
      #   end
      # end
      
      
      def locate_config_value(key)
        key = key.to_sym
        Chef::Config[:knife][key] || config[key]
      end

      def msg_pair(label, value, color=:cyan)
        if value && !value.to_s.empty?
          puts "#{ui.color(label, color)}: #{value}"
        end
      end

    end
  end
end


