module Guard
  module Rackunit
    class Runner

      def initialize(run_file_name)
        @run_file_name = run_file_name
      end

      def run
        success = system("racket #{@run_file_name}")
        if !success
          Notifier.notify("Failed", :title => 'Rackunit results')
        end
      end
    end
  end
end
