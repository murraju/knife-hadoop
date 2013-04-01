# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-hadoop/version"

Gem::Specification.new do |s|
  s.name        = "knife-hadoop"
  s.version     = Knife::Hadoop::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.authors     = ["Murali Raju"]
  s.email       = ["murraju@appliv.com"]
  s.homepage    = "https://github.com/murraju/knife-hadoop"
  s.summary     = %q{Hadoop Chef Knife Plugin}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "webhdfs"
  s.add_dependency "pg"
  #s.add_dependency "sqlite3"
  s.add_dependency "sequel"
  s.add_dependency "debugger"
  s.add_dependency "rest-client"
  s.add_dependency "chef", "> 10.24.0"
end
