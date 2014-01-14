require 'guard/plugin'

module Guard
  class RackUnit < Plugin

    require_relative 'rack_unit/runner'

    # Initializes a Guard plugin.
    # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Hash] options the custom Guard plugin options
    # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(options = {})
      super
      @start_on_run = options.delete(:all_on_start) || false
      @test_directory = options.delete(:test_directory) || []
      @runner = RackUnit::Runner.new
    end

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      ::Guard::UI.info 'Guard::RackUnit is running'
      return run_all if @start_on_run
      pending_result
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      return pending_result unless test_directory?
      Guard::UI.info("Resetting", reset: true)
      do_run{ @runner.run(@test_directory) }
    end

    # Called on file(s) modifications that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_modifications has failed
    # @return [Object] the task result
    #
    def run_on_modifications(paths)
      return pending_result if paths.empty?
      Guard::UI.info("Running: #{paths.join(', ')}", reset: true)
      do_run{ @runner.run(paths) }
    end

    private
    def do_run
      run_result = yield
      run_result.issue_notification
      run_result.successful? ? run_result : throw(:task_has_failed)
    end

    def test_directory?
      !@test_directory.nil? && !@test_directory.empty?
    end

    def pending_result
      @pending ||= RunResult::Pending.new
    end
  end
end
