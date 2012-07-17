# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'bartender/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel Westendorf"]
  gem.email         = ["daniel@prowestech.com"]
  gem.description   = %q{Build static websites smartly}
  gem.summary       = %q{Use layouts, link helpers, and the asset pipeline to create static websites smartly.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "static-bartender"
  gem.require_paths = ["lib"]
  gem.version       = Bartender::VERSION
  gem.add_dependency "deep_merge"
  gem.add_dependency "tilt"
  gem.add_dependency "sprockets"
end
