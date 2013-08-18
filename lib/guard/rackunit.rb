require 'guard'
require 'guard/guard'

module Guard

  class Rackunit < Guard

    #autoload :Runner, 'guard/rackunit/runner'

    def initialize(watchers = [], options = {})
      super
      run_file_name = options[:test_runner_rkt] || "test-runner.rkt"
      @runner = Runner.new(run_name_file)
    end

    def run_all
      @runner.run
    end

    def start
      UI.info "#{self.class.name} is running"
    end
  end
end
