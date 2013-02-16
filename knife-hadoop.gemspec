# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-hadoop/version"

Gem::Specification.new do |s|
  s.name        = "knife-hadoop"
  s.version     = Knife::Ucs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.authors     = ["Murali Raju"]
  s.email       = ["murraju@appliv.com"]
  s.homepage    = "https://github.com/velankanisys/knife-hadoop"
  s.summary     = %q{Hadoop Chef Knife Plugin}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "webhdfs"
  s.add_dependency "chef", "~>10.16.2"
end