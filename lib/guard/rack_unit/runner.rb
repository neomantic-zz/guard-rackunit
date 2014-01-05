require_relative './command'
require_relative './notifier'
require 'open3'
require 'set'

module Guard
  class RackUnit
    class Runner

      require_relative './inspectors/focused_inspector'

      def initialize(options = {})
        # HACK - options may be useless
        @options = options
        @inspector = RackUnit::Inspectors::FocusedInspector.new(@options)
        @notifier = Notifier.new(@options)
      end

      def run(paths)
        paths = @inspector.paths(paths)
        return true if paths.empty?
        ::Guard::UI.info("Running: #{paths.join(' ')}", reset: true)
        run_tests(false, paths)
      end

      def run_all
        # HACK
        paths = @options[:spec_paths] || ["tests/"]
        return true if paths.empty?
        ::Guard::UI.info("Running All", reset: true)
        run_tests(true, paths)
      end

      def reload
        @inspector.reload
      end

      private

      def run_tests(all, paths)
        success_msg = ""
        set = Set.new([])
        execute_with_bundler do
          Open3.popen3(Command.new(paths)) do |stdin, stdout, stderr, wait_thr|
            pid = wait_thr.pid
            exit_status = wait_thr.value
            if exit_status.success?
              success_msg = stdout.read
            else
              stderr.each_line do |line|
                match_data = line.match(/\Alocation:.+path:(.+)>/)
                unless match_data.nil?
                  set.add match_data[1]
                end
              end
            end
          end
        end
        if successful_run?
          # HACK
          @notifier.notify("")
        else
          @notifier.notify_failure
        end
      end

      def execute_with_bundler
        if defined?(::Bundler)
          ::Bundler.with_clean_env { yield }
        else
          yield
        end
      end

      def successful_run?
        # HACK
        #@last_run
        true
      end
    end
  end
end
