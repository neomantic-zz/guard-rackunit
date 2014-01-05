require 'guard/rack_unit/inspectors/focused_inspector'
require 'guard/rack_unit/command'
require 'guard/rack_unit/notifier'

module Guard
  class Rackunit
    class Runner

      def initialize(options = {})
        # HACK - options may be useless
        @options = options
        @inspector = Inspectors::FocusedInspector.new(@options)
        @notifier = Notifier.new(@options)
      end

      def run(paths)
        paths = inspector.paths(paths)
        return true if paths.empty?
        ::Guard::UI.info("Running: #{paths.join(' ')}", reset: true)
        run_tests(false, paths)
      end

      def run_all
        # HACK
        paths = options[:spec_paths] || "tests/"
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
        success = without_bundler_env {Kernel.system(command)}
        if successful_run?
          @notifier.notify
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

      def successful_run?(results)
        true
      end


      # def run_paths(paths)
      #   spawn("racket -e '(require rackunit/test-ui) ")
      # end

      # class Run

      #   def initialize(errors)
      #     @errors = errors
      #     unless success?
      #       puts @errors
      #     end
      #   end

      #   def success?
      #     @errors.empty?
      #   end

      #   def failed_paths
      #     @errors.split(/location:\s+(.+.rkt)/i)
      #   end
      # end
    end
  end
end
