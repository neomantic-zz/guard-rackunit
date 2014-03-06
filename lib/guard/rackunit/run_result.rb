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

require 'set'
require_relative './notifier'
module Guard
  class RackUnit
    class RunResult

      def self.create(stdout, stderr)
        err_byte = stderr.getbyte
        if err_byte.nil?
          Success.new(stdout)
        else
          puts stdout.readlines
          stderr.ungetbyte(err_byte)
          Failure.new(stderr)
        end
      end

      class Pending
        def issue_notification; end
        def paths; Set[]; end
        def successful?; false; end
      end

      class Success

        def initialize(result_io)
          @message = "Success"
          result_io.each_line do |line|
            puts @message = line
          end
          @message.chomp!
        end

        def issue_notification
          Notifier.new(@message).notify NOTIFY_OPTIONS
        end

        def paths; Set[]; end

        def successful?; true; end

        private
        NOTIFY_OPTIONS = {image: :success, priority: -2}.freeze

      end


      class Failure

        def initialize(stderr)
          @message = "Failed"
          @failed_paths_set = Set[]
          stderr.each_line do |line|
            puts line # give user some feedback

            if line =~ ERROR_REGEX
              # an exception as raised
              @message = stderr.readline
              puts @message
              @message = "ERROR: #{@message.strip}"
              stderr.each_line{|line| puts line}
            else
              match_data = line.match(FAILURE_REGEX)
              unless match_data.nil?
                @failed_paths_set.add(match_data[1])
              else
                # the last line should have the results summary
                @message = line
              end
            end
          end
          @message.chomp!
        end

        def issue_notification
          Notifier.new(@message).notify NOTIFY_OPTIONS
        end

        def paths
          @failed_paths_set || Set[]
        end

        def successful?; false; end

        private
        FAILURE_REGEX = /\Alocation:.+path:(.+)>/
        NOTIFY_OPTIONS = {image: :failed, priority: 2}.freeze
        ERROR_REGEX = /context#{Regexp.escape('...')}:/
      end
    end
  end
end
