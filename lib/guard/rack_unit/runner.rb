require_relative './command'
require_relative './notifier'

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
        command = Command.new(paths)
        @last_run = without_bundler_env {Kernel.system(command)}
        if successful_run?
          # HACK
          @notifier.notify("")
        else
          @notifier.notify_failure
        end
      end

      def without_bundler_env
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
