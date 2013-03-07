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

require 'chef/knife'
require 'webhdfs'
require 'debugger'
require 'sequel'
require 'rest-client'
require 'json'

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

          option :db_type,
            :short => "-T DATABASETYPE",
            :long => "--database-type DATABASETYPE",
            :description => "PostgreSQL or Sqlite Database to use for Hadoop Management Data",
            :proc => Proc.new { |key| Chef::Config[:knife][:db] = key }

          option :db,
            :short => "-D DATABASE",
            :long => "--database DATABASE",
            :description => "PostgreSQL Database to use for Hadoop Management Data",
            :proc => Proc.new { |key| Chef::Config[:knife][:db] = key }

          option :db_username,
            :short => "-B DBUSERNAME",
            :long => "--db-username DBUSERNAME",
            :description => "PostgreSQL DB Username",
            :proc => Proc.new { |key| Chef::Config[:knife][:db_username] = key }

          option :db_password,
            :short => "-C DBPASSWORD",
            :long => "--db-password DBPASSWORD",
            :description => "PostgreSQL DB Password",
            :proc => Proc.new { |key| Chef::Config[:knife][:db_password] = key }

          option :db_host,
            :short => "-I DBHOST",
            :long => "--db-host DBHOST",
            :description => "PostgreSQL DB Host",
            :proc => Proc.new { |key| Chef::Config[:knife][:db_host] = key }

            option :db_port,
              :short => "-F DBPORT",
              :long => "--db-port DBPORT",
              :description => "PostgreSQL DB Port",
              :proc => Proc.new { |key| Chef::Config[:knife][:db_port] = key }
          
        end
      end

      def hdfs_connection
        Chef::Log.debug("username: #{Chef::Config[:knife][:namenode_username]}")
        Chef::Log.debug("password: #{Chef::Config[:knife][:namenode_password]}")
        Chef::Log.debug("host:     #{Chef::Config[:knife][:namenode_host]}")
        Chef::Log.debug("port:     #{Chef::Config[:knife][:namenode_port]}")
        @hdfs_connection ||= begin
          hdfs_connection = WebHDFS::Client.new("#{Chef::Config[:knife][:namenode_host]}", 
                                           "#{Chef::Config[:knife][:namenode_port]}",
                                           "#{Chef::Config[:knife][:namenode_username]}")
        end
      end

      def db_connection
        Chef::Log.debug("db_type: #{Chef::Config[:knife][:db_type]}")
        Chef::Log.debug("db: #{Chef::Config[:knife][:db]}")
        Chef::Log.debug("db_username: #{Chef::Config[:knife][:db_username]}")
        Chef::Log.debug("db_password: #{Chef::Config[:knife][:db_password]}")
        Chef::Log.debug("db_host: #{Chef::Config[:knife][:db_host]}")
        Chef::Log.debug("db_port: #{Chef::Config[:knife][:db_port]}")
        db_type = "#{Chef::Config[:knife][:db_type]}".downcase
        case db_type
        when 'postgres'
          @db_connection ||= begin
            db_connection = Sequel.postgres("#{Chef::Config[:knife][:db]}", :user=>"#{Chef::Config[:knife][:db_username]}", 
                                             :password => "#{Chef::Config[:knife][:db_password]}", :host => "#{Chef::Config[:knife][:db_host]}", 
                                             :port => "#{Chef::Config[:knife][:db_port]}", :max_connections => 10)
          end
        when 'sqlite'
          @db_connection ||= begin
            db_connection = Sequel.sqlite("#{Chef::Config[:knife][:db]}")
          end
        end
      end

      
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


