# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_service_mapper/version'

Gem::Specification.new do |gem|
  gem.name          = "active_service_mapper"
  gem.version       = ActiveServiceMapper::VERSION
  gem.authors       = ["Bhaskar Sundarraj"]
  gem.email         = ["bhaskar.sundarraj@gmail.com"]
  gem.description   = %q{This gem will provide a mapping functionality (like automapping service layer to the model) for projects which deal with services- preferably json responses.}
  gem.summary       = %q{This gem will provide a mapping functionality (like automapping service layer to the model) for projects which deal with services- preferably json responses.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'plain_old_model'
  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-core'
end
