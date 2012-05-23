# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "milksteak/version"
require "milksteak/cms"

Gem::Specification.new do |s|
  s.name        = "milksteak"
  s.version     = Milksteak::VERSION
  s.authors     = ["Bryan Thompson"]
  s.email       = ["bryan.thompson@firespring.com"]
  s.homepage    = ""
  s.summary     = %q{the cms that doesn't give a damn}
  s.description = %q{really. it's just simple.}

  s.rubyforge_project = "milksteak"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "webmock"
  s.add_development_dependency "rack-test"

  #going to a simple flat-file storage for now
  #s.add_runtime_dependency "tonic-cms"
 
  s.add_runtime_dependency "liquid"
  s.add_runtime_dependency "BlueCloth"
  s.add_runtime_dependency "sinatra"
end
