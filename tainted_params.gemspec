# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'tainted_params/version'

Gem::Specification.new do |s|
  s.name        = "tainted_params"
  s.version     = TaintedParams::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ragmaanir"]
  s.email       = ["ragmaanir@gmail.com"]
  s.homepage    = "http://github.com/ragmaanir/tainted_params"
  s.license     = 'MIT'
  s.summary     = "Similar to strong_parameters, with some enhancements"
  s.description = 'Similar to strong_parameters, but adds type validation and makes it possible to retrieve the invalid or unpermitted parameters'

  s.required_rubygems_version = "~> 2.2"
  s.required_ruby_version     = "~> 2.1"
  s.rubyforge_project         = "tainted_params"

  s.add_development_dependency "rspec", '~> 3.0'
  s.add_development_dependency 'wrong', '~> 0.7'

  s.add_development_dependency 'pry', '~> 0.9'
  s.add_development_dependency 'binding_of_caller', '~> 0.7'

  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.test_files   = Dir.glob("spec/**/*_spec.rb")
  s.require_path = 'lib'
end
