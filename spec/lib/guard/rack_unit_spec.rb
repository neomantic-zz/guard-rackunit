require 'spec_helper'

describe Guard::RackUnit do
  it "is a plugin" do
    expect(described_class.new).to be_kind_of Guard::Plugin
  end

  describe "start" do
    context "when all_on_start is enabled" do
      let(:test_directory){['/tests']}
      let(:instance){described_class.new({all_on_start: true, test_directory: test_directory})}

      it "returns a success result on success" do
        stub_successful_run(test_directory) do
          result = instance.start
          expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
        end
      end

      it "throw a :task_has_failed symbol when it has a test directory" do
        stub_failed_run(test_directory) do
          expect{instance.start}.to throw_symbol :task_has_failed
        end
      end

      it "returns a failure result on failure when it has a test directory" do
        result = described_class.new({all_on_start: true}).start
        expect(result).to be_instance_of Guard::RackUnit::RunResult::Pending
      end

      it "updates the UI" do
        expect(::Guard::UI).to receive(:info).at_least(:once).ordered.with('Guard::RackUnit is running')
        expect(::Guard::UI).to receive(:info).at_least(:once).ordered.with('Resetting', reset: true)
        catch(:task_has_failed){instance.start}
      end
    end

    context "when all_on_start is not enabled" do
      let(:instance){described_class.new}

      it "updates the UI telling the user it has started" do
        expect(::Guard::UI).to receive(:info).with('Guard::RackUnit is running')
        instance.start
      end

      it "updates the UI telling the user it has started" do
        expect(instance.start).to be_instance_of Guard::RackUnit::RunResult::Pending
      end
    end
  end

  describe "run_all" do

    let(:test_directory) { ['tests/'] }
    let(:instance){described_class.new({test_directory: test_directory})}

    context "success" do
      it "returns a success result on success" do
        stub_successful_run(test_directory) do
          expect(instance.run_all).to be_instance_of Guard::RackUnit::RunResult::Success
        end
      end

      it "issues a notification" do
        expect(Guard::Notifier).to receive(:notify).with("8 tests passed", {title: 'RackUnit Results', image: :success, priority: -2})
        stub_successful_run(test_directory) do
          instance.run_all
        end
      end
    end

    context "failure" do
      it "returns a failure result on failure" do
        stub_failed_run(test_directory) do
          expect{instance.run_all}.to throw_symbol :task_has_failed
        end
      end

      it "issues a notification" do
        stub_failed_run(test_directory) do
          expect(Guard::Notifier).to receive(:notify).with("1/101 test failures", {title: 'RackUnit Results', image: :failed, priority: 2})
          catch(:task_has_failed){instance.run_all }
        end
      end
    end

    it "issues a notification" do
      expect(Guard::UI).to receive(:info).with("Resetting", reset: true)
      stub_successful_run(test_directory) do
        instance.run_all
      end
    end
  end

  describe "running on modifications" do
    let(:instance){described_class.new}

    context "with no supplied paths" do
      it "does not issue a notification when the path is empty" do
        expect(Guard::UI).to_not receive(:info)
        instance.run_on_modifications([])
      end
    end

    context "with paths" do

      let(:test_paths){['/paths/test.rkt', '/paths/another.rkt']}

      it "issues a notification" do
        expect(Guard::UI).to receive(:info).with("Running: #{test_paths.join(', ')}", reset: true)
        stub_successful_run(test_paths) do
          instance.run_on_modifications(test_paths)
        end
      end

      it "returns a success result on success" do
        stub_successful_run(test_paths) do
          result = instance.run_on_modifications(test_paths)
          expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
        end
      end

      it "throws a :task_has_failed symbol on failure" do
        stub_failed_run(test_paths) do
          expect do
            result = instance.run_on_modifications(['/paths/test.rkt', '/paths/another.rkt'])
            expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
          end
        end
      end
    end
  end
end
