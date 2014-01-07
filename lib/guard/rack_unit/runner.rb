require_relative './run_result'
require_relative './command'

module Guard
  class RackUnit
    class Runner

      def initialize(options = {})
        @options = options
        @last_run_result = RunResult::Pending.new
      end

      def run_on_paths(paths)
        return true if paths.empty?
        run_tests("Running: #{paths.join(' ')}") do |command|
          command.execute(paths)
        end
      end

      def run_all
        return true if @options[:test_directory].nil?
        run_tests("Resetting") do |command|
          command.execute([@options[:test_directory] + "*.rkt"])
        end
      end

      private

      def run_tests(ui_message)
        ::Guard::UI.info(ui_message, reset: true)
        @last_run_result = yield Command.new(@last_run_result)
        @last_run_result.issue_notification
        @last_run_result
      end
    end
  end
end
