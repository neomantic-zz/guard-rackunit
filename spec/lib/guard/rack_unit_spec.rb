require 'spec_helper'

describe Guard::RackUnit do
  it "is a plugin" do
    expect(described_class.new).to be_kind_of Guard::Plugin
  end

  describe "start when running all is enabled" do
    context "when all_on_start is enabled" do
      let(:instance){described_class.new({all_on_start: true, test_directory: ['/tests']})}

      it "returns a success result on success" do
        stub_successful_run do
          result = instance.start
          expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
        end
      end

      it "throw a :task_has_failed symbol when it has a test directory" do
        stub_failed_run do
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

    let(:instance){described_class.new({test_directory: ['tests/']})}

    context "success" do
      it "returns a success result on success" do
        stub_successful_run do
          expect(instance.run_all).to be_instance_of Guard::RackUnit::RunResult::Success
        end
      end

      it "issues a notification" do
        expect(Guard::Notifier).to receive(:notify).with("8 tests passed", {title: 'RackUnit Results', image: :success, priority: -2})
        stub_successful_run do
          instance.run_all
        end
      end
    end

    context "failure" do
      it "returns a failure result on failure" do
        stub_failed_run do
          expect{instance.run_all}.to throw_symbol :task_has_failed
        end
      end

      it "issues a notification" do
        stub_failed_run do
          expect(Guard::Notifier).to receive(:notify).with("1/101 test failures", {title: 'RackUnit Results', image: :failed, priority: 2})
          catch(:task_has_failed){instance.run_all }
        end
      end
    end

    it "issues a notification" do
      expect(Guard::UI).to receive(:info).with("Resetting", reset: true)
      stub_successful_run do
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

      it "issues a notification" do
        expect(Guard::UI).to receive(:info).with("Running: /paths/test.rkt, /paths/another.rkt", reset: true)
        stub_successful_run do
          instance.run_on_modifications(['/paths/test.rkt', '/paths/another.rkt'])
        end
      end

      it "returns a success result on success" do
        stub_successful_run do
          result = instance.run_on_modifications(['/paths/test.rkt', '/paths/another.rkt'])
          expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
        end
      end

      it "throws a :task_has_failed symbol on failure" do
        stub_failed_run do
          expect do
            result = instance.run_on_modifications(['/paths/test.rkt', '/paths/another.rkt'])
            expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
          end
        end
      end

      context "with other failed tasks" do

        it "run all previous failed paths" do
          failed_output =<<FAILED
--------------------
parsing: """
FAILURE
message:    "No exception raised"
name:       check-exn
location:   (#<path:/home/test-user/tests.rkt> 19 4 389 113)
expression: (check-exn exn:fail:parsack? (lambda () (parsack-parse string)))
params:     (#<procedure:exn:fail:parsack?> #<procedure:temp6>)

Check failure
--------------------
1/101 test failures
FAILED
          stub_failed_run_err(StringIO.new(failed_output)) do
            catch(:task_has_failed) do
              instance.run_on_modifications(['/home/test-user/tests.rkt'])
            end
          end
          expect(Open3).to receive(:popen3).with('raco test /home/test-user/tests.rkt /paths/test.rkt /paths/another.rkt')
          catch(:task_has_failed) do
            instance.run_on_modifications(['/paths/test.rkt', '/paths/another.rkt'])
          end
        end
      end
    end
  end
end
