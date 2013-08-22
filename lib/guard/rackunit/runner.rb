require 'guard/guard'

module Guard
  class Rackunit

    class Runner

      attr_reader :last_run

      def initialize(run_file_name)
        @run_file_name = run_file_name
      end

      def run
        err_reader, err_writer = IO.pipe
        pid = spawn("racket #{@run_file_name}", :err => err_writer)
        Process.wait pid
        err_writer.close
        @last_run = Run.new(err_reader.read)
        err_reader.close
        @last_run
      end

      def run_paths(paths)
        spawn("racket -e '(require rackunit/test-ui) ")
      end

      class Run

        def initialize(errors)
          @errors = errors
          unless success?
            puts @errors
          end
        end

        def success?
          @errors.empty?
        end

        def failed_paths
          @errors.split(/location:\s+(.+.rkt)/i)
        end
      end
    end
  end
end
