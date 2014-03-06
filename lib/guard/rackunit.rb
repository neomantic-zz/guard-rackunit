require 'guard/plugin'
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

module Guard
  class RackUnit < Plugin

    require_relative 'rackunit/runner'

    # Initializes a Guard plugin.
    # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Hash] options the custom Guard plugin options
    # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(options = {})
      super
      @start_on_run = options.delete(:all_on_start) || false
      @test_paths = options.delete(:test_paths) || []
      @runner = RackUnit::Runner.new
    end

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      ::Guard::UI.info 'Guard::RackUnit is running'
      return run_all if @start_on_run
      pending_result
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      return pending_result unless test_paths?
      Guard::UI.info("Resetting", reset: true)
      do_run{ @runner.run(@test_paths) }
    end

    # Called on file(s) modifications that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_modifications has failed
    # @return [Object] the task result
    #
    def run_on_modifications(paths)
      return pending_result if paths.empty?
      Guard::UI.info("Running: #{paths.join(', ')}", reset: true)
      do_run{ @runner.run(paths) }
    end

    private
    def do_run
      run_result = yield
      run_result.issue_notification
      run_result.successful? ? run_result : throw(:task_has_failed)
    end

    def test_paths?
      !@test_paths.nil? && !@test_paths.empty?
    end

    def pending_result
      @pending ||= RunResult::Pending.new
    end
  end
end
