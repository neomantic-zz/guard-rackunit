# Guard::RackUnit
# Copyright (C) 2014 Chad Albers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require_relative './run_result'
require_relative './command'

module Guard
  class RackUnit
    class Runner

      def initialize
        @last_run_result = pending_result
      end

      # This class runs a Command (which will be customizable)
      # And produces a run result
      def run(paths = [])
        if paths.empty?
          pending_result
        else
          path_set = PathSet.new(@last_run_result.paths, Set.new(paths))
          @last_run_result = Command.new.execute(path_set.to_a)
          @last_run_result
        end
      end

      private
      def pending_result
        RunResult::Pending.new
      end

    end


    class PathSet

      def initialize(previous_set, new_set)
        @set = previous_set | select_existing(new_set)
      end

      def to_a
        @set.to_a
      end

      private
      def select_existing(paths)
        paths.select{|path| File.exists?(path)}
      end
    end
  end
end
