require 'guard'
require File.expand_path('../lib/guard/rackunit', __FILE__)
require File.expand_path('../lib/guard/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'guard-rackunit'
  s.version = Guard::Rackunit::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = ['Chad Albers']
  s.email = 'calbers@neomantic.com'
  s.summary = 'guard-racketunit is a guard plugin to run Racket Rackunit unit-tests'
  s.homepage = "https://github.com/neomantic/guard-rackunit"
  s.files = Dir['lib/**/*']
  s.require_path = ['lib']

  s.add_dependency 'guard', '>= 1.8'

end
