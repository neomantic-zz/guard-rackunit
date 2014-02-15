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
  s.license = 'GNU General Public License v3'

  s.add_runtime_dependency 'guard', ['~> 2.4.0']

  s.add_development_dependency 'guard-rspec', ['~> 4.2.3']
  s.add_development_dependency 'rspec', ['~> 2.14.1']
  s.add_development_dependency 'debugger', ['~> 1.6.5']
end
