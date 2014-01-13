require 'open3'
require_relative './run_result'
module Guard
  class RackUnit
    class Command

      def execute(paths)
        return RunResult::Pending.new if paths.empty?
        cmd = sprintf('%s %s', DEFAULT_CMD_STR, paths.join(' '))
        with_environment do
          Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
            pid = wait_thr.pid
            wait_thr.value
            RunResult.create(stdout, stderr)
          end
        end
      end

      def with_environment
        if defined?(::Bundler)
          ::Bundler.with_clean_env { yield }
        else
          yield
        end
      end

      private
      DEFAULT_CMD_STR = 'raco test'.freeze

    end
  end
end
