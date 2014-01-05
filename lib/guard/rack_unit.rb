require 'guard'
require 'guard/plugin'
require 'guard/rack_unit/runner'

module Guard
  class RackUnit < Plugin

    def initialize(options={})
      super
      @runner = Runner.new
    end

    def start
      ::Guard::UI.info 'Guard::RackUnit is running'
      run_all
    end

    def run_all
      @runner.run_all
    end

    def reload
      @runner.reload
    end

    def run_on_modifications(paths)
      return false if paths.empty?
      @runner.run(paths)
    end
  end
end
