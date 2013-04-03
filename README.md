Knife Hadoop 
===============

This is a Chef Knife plugin for Hadoop. This plugin gives knife the ability to provision, list, and manage Hadoop for Operators. 

Version 0.1.0
Chef 11.x

Version 0.0.9

Added PostgreSQL port option
General clean up


Version 0.0.8

Bug Fixes.

Features:

HDFS APIs (currently supported) using the ruby webhdfs gem: https://github.com/kzk/webhdfs. Extensions to webhdfs will be hosted at 
https://github.com/murraju/webhdfs
	
	a. List Directories and Files
	b. Snapshot metadata information to a database (PostgreSQL or Sqlite). Useful for reporting and audits
	c. Create Directories and Files
	d. Update Files
	e. Read Files

MapReduce APIs supported using the awesome work done by huahin: https://github.com/huahin

	a. Start/List/Kill MapReduce Jobs by JobID and JobName



Issues:

1. The WebHDFS gem has bugs on net-http for create/delete.
2. Not all methods are exposed.
3. HDFS usage still in development.




# Installation #

Be sure you are running the latest version Chef. Versions earlier than 0.10.0 don't support plugins:

    $ gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    $ gem install knife-hadoop
	
	For JRuby, make sure to have the following in ~/.jrubyc:
	compat.version=1.9
	cext.enabled=true
	errno.backtrace=true

Depending on your system's configuration, you may need to run this command with root privileges.

# Configuration #

In order to communicate with Hadoop and other APIs, you will have to set parameters. The easiest way to accomplish this is to create some entries in your `knife.rb` file:

	knife[:namenode_host]   	= "namenode"
	knife[:namenode_port]   	= "port"
	knife[:namenode_username] 	= "namenode_username"
	knife[:mapred_mgmt_host]    = "mapred_mgmt_host"
	knife[:mapred_mgmt_port]    = "mapred_mgmt_port"
	knife[:db_type]				= "db_type"
	knife[:db_username] 		= "dbusername"
	knife[:db_password] 		= "dbpassword"
	knife[:db_host] 			= "dbhost"
	knife[:db_host] 			= "port"
	knife[:db] 					= "db"

If your knife.rb file will be checked into a SCM system (ie readable by others) you may want to read the values from environment variables:

	knife[:namenode_host]   	= "#{ENV['NAMENODE_HOST']}"
	knife[:namenode_port]   	= "#{ENV['NAMENODE_PORT']}"
	knife[:namenode_username] 	= "#{ENV['NAMENODE_USERNAME']}"
	knife[:mapred_mgmt_host]    = "#{ENV['MAPRED_MGMT_HOST']}"
	knife[:mapred_mgmt_port]    = "#{ENV['MAPRED_MGMT_PORT']}"
	knife[:db_type] 			= "#{ENV['DB_TYPE']}"
	knife[:db_username] 		= "#{ENV['DB_USERNAME']}"
	knife[:db_password] 		= "#{ENV['DB_PASSWORD']}"
	knife[:db_host] 			= "#{ENV['DB_HOST']}"
	knife[:db_host] 			= "#{ENV['DB_PORT']}"
	knife[:db] 					= "#{ENV['DB']}"



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
