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
