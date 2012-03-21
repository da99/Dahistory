# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "Dahistory/version"

Gem::Specification.new do |s|
  s.name        = "Dahistory"
  s.version     = Dahistory::VERSION
  s.authors     = ["da99"]
  s.email       = ["i-hate-spam-45671204@mailinator.com"]
  s.homepage    = "https://github.com/da99/Dahistory"
  s.summary     = %q{Compare file to previous history and backup.}
  s.description = %q{Compares file to other files in specified dir(s) and backups if it does not exist.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bacon"
  s.add_development_dependency "rake"
  s.add_development_dependency 'Bacon_Colored'
  s.add_development_dependency 'pry'
  
  # s.rubyforge_project = "Dahistory"
  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"
end
