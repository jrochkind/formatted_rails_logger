# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "formatted_rails_logger/version"

Gem::Specification.new do |s|
  s.name        = "formatted_rails_logger"
  s.version     = FormattedRailsLogger::VERSION
  s.authors     = ["Jonathan Rochkind"]
  s.email       = ["jonathan@dnil.net"]
  s.homepage    = "https://github.com/jrochkind/formatted_rails_logger"
  s.summary     = %q{Formatting capabilities for Rails BufferedLogger}  

  s.rubyforge_project = "formatted_rails_logger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
