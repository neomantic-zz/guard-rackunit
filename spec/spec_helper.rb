# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'rspec'
require 'rspec/mocks'
require 'debugger'
Debugger.start
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.before do
    stub_successful_run
  end
end
