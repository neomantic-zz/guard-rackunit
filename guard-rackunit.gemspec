require File.expand_path('../lib/guard/rack_unit', __FILE__)
require File.expand_path('../lib/guard/rack_unit/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'guard-rackunit'
  s.version = Guard::RackUnit::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = ['Chad Albers']
  s.email = 'calbers@neomantic.com'
  s.summary = "Guard gem for Racket's RackUnit"
  s.description = "Guard::RackUnit runs Racket RackUnit tests"
  s.homepage = "https://github.com/neomantic/guard-rackunit"
  s.files = Dir['lib/**/*']
  s.require_path = ['lib']
  s.license = 'MIT'

  s.add_runtime_dependency 'guard', ['~> 2.2.5']

end
