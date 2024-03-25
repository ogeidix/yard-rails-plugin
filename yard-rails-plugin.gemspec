# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yard-rails-plugin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Nagy"]
  gem.email         = ["peter@antronin.consulting"]
  gem.summary       = "YARD plugin to document a Rails project" 
  gem.homepage      = "https://github.com/Antronin/yard-rails-plugin"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yard-rails-plugin"
  gem.require_paths = ["lib"]
  gem.version       = YARD::Rails::Plugin::VERSION

  gem.add_dependency 'yard', '> 0.7'
end
