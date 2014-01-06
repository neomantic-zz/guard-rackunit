require 'open3'
require 'set'

module Guard
  class RackUnit
    class Runner

      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
        @failed_paths_set = Set[]
      end

      def run_on_paths(paths)
        if @options[:keep_failed]
          paths = (@failed_paths_set | paths).to_a
        end
        return true if paths.empty?
        ::Guard::UI.info("Running: #{paths.join(' ')}", reset: true)
        run_tests(false, paths)
      end

      def run_all
        return true if @options[:test_directory].nil?
        paths = [@options[:test_directory] + "*.rkt"]
        ::Guard::UI.info("Resetting", reset: true)
        run_tests(true, paths)
      end

      private

      FAILURE_REGEX = /\Alocation:.+path:(.+)>/
      COMMAND = 'raco test'.freeze

      DEFAULT_OPTIONS = {
        keep_failed: true
      }.freeze

      DEFAULT_NOTIFY_OPTIONS = {
        title: 'RackUnit Results',
      }.freeze

      SUCCESS_NOTIFY_OPTIONS = DEFAULT_NOTIFY_OPTIONS.
        merge({image: :success, priority: -2})

      FAILURE_NOTIFY_OPTIONS = DEFAULT_NOTIFY_OPTIONS.
        merge({image: :failed, priority: 2})

      def run_tests(all, paths)
        cmd = sprintf('%s %s', COMMAND, paths.join(' '))
        message, notify_options = execute_in_environment do
          Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
            pid = wait_thr.pid
            exit_status = wait_thr.value
            stdout_message = stdout.read
            # give the user some feedback
            puts stdout_message
            if exit_status.success?
              @failed_paths_set = Set[]
              [stdout_message, SUCCESS_NOTIFY_OPTIONS]
            else
              results_message = 'failures'
              stderr.each_line do |line|
                puts line # give user some feedback
                if @options[:keep_failed]
                  match_data = line.match(FAILURE_REGEX)
                  unless match_data.nil?
                    @failed_paths_set.add(match_data[1])
                  else
                    # the last line should have the results only
                    results_message = line
                  end
                end
              end
              [results_message, FAILURE_NOTIFY_OPTIONS]
            end
          end
        end
        ::Guard::Notifier.notify(message, notify_options)
      end

      def execute_in_environment
        if defined?(::Bundler)
          ::Bundler.with_clean_env { yield }
        else
          yield
        end
      end
    end
  end
end
