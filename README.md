Knife Hadoop (beta)
===============

This is a Chef Knife plugin for Hadoop. This plugin gives knife the ability to provision, list, and manage Hadoop for Operators. 

Features:

1. HDFS APIs (currently supported) using the ruby webhdfs gem: https://github.com/kzk/webhdfs. 
	Extensions to webhdfs will be hosted at https://github.com/murraju/webhdfs
	a. List Directories and Files
	b. Snapshot to database (PostgreSQL for now)
2. MapReduce management is in development with a wrapper gem using JRuby: http://github.com/murraju/mapredlib (will be released soon)
	a. List jobs by ID [TODO]
	b. Kills jobs by ID [TODO]

# Installation #

Be sure you are running the latest version Chef. Versions earlier than 0.10.0 don't support plugins:

    $ gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    $ gem install knife-hadoop

Depending on your system's configuration, you may need to run this command with root privileges.

# Configuration #

In order to communicate with Cisco UCS XML API you will have to tell Knife the username, password and the IP address of the UCS Manager. The easiest way to accomplish this is to create some entries in your `knife.rb` file:

	knife[:namenode_host]   = "namenode"
	knife[:namenode_port]   = "port"
	knife[:db_username] 	= "dbusername"
	knife[:db_password] 	= "dbpassword"
	knife[:db_host] 		= "dbhost"
	knife[:db] 				= "db"

If your knife.rb file will be checked into a SCM system (ie readable by others) you may want to read the values from environment variables:

	knife[:namenode_host]   = "#{ENV['NAMENODE_HOST']}"
	knife[:namenode_port]   = "#{ENV['NAMENODE_PORT']}"
	knife[:db_username] 	= "#{ENV['DB_USERNAME']}"
	knife[:db_password] 	= "#{ENV['DB_PASSWORD']}"
	knife[:db_host] 		= "#{ENV['DB_HOST']}"
	knife[:db] 				= "#{ENV['DB']}"



# License #

Author:: Murali Raju <murali.raju@appliv.com>

Copyright:: Copyright (c) 2012 Murali Raju <murali.raju@appliv.com>

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
