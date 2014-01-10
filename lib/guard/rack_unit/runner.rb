require_relative './run_result'
require_relative './command'

module Guard
  class RackUnit
    class Runner

      # This class runs a Command (which will be customizable)
      # And produces a run result
      def run(paths = [])
        return RunResult::Pending.new if paths.empty?
        Command.new.execute(paths)
      end
    end
  end
end
