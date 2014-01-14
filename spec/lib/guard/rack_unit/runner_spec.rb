require 'spec_helper'

describe Guard::RackUnit::Runner do

  let(:instance){described_class.new}
  let(:paths){['some_paths/']}

  context "success" do
    it "runs test with the given paths and returns a success result " do
      stub_successful_run(paths) do
        result = instance.run paths
        expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
      end
    end
  end

  context "failure" do
    it "runs test with the given paths and returns a failure result " do
      stub_failed_run(paths) do
        result = instance.run(paths)
        expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
      end
    end
  end

  it 'returns pending result when no paths have been supplied' do
    expect(instance.run([])).to be_instance_of Guard::RackUnit::RunResult::Pending
  end


  it "does not run duplicates" do
    paths_with_dups = ['/home/test-user/tests.rkt', '/home/test-user/tests.rkt']
    expect(Open3).to receive(:popen3).with('raco test /home/test-user/tests.rkt')
    stub_successful_run(paths_with_dups) do
      instance.run(paths_with_dups)
    end
  end

  context "with other failed tasks" do
    let(:failed_output) do
      <<FAILED
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
    end

    it "run all previous failed paths" do
      stub_failed_run_err(StringIO.new(failed_output), '/home/test-user/tests.rkt') do
        catch(:task_has_failed) do
          instance.run(['/home/test-user/tests.rkt'])
        end
      end
      expect(Open3).to receive(:popen3).with('raco test /home/test-user/tests.rkt /paths/test.rkt /paths/another.rkt')
      stub_successful_run(['/home/test-user/tests.rkt','/paths/test.rkt', '/paths/another.rkt']) do
        instance.run(['/paths/test.rkt', '/paths/another.rkt'])
      end
    end

    it "does not run duplicates when new tests are added to the previous failed" do
      first_path = '/home/test-user/tests.rkt'
      stub_failed_run_err(StringIO.new(failed_output), '/home/test-user/tests.rkt') do
        catch(:task_has_failed) do
          instance.run(['/home/test-user/tests.rkt'])
        end
      end
      new_path = '/new/path.rkt'
      new_paths = [first_path, first_path, new_path]
      expect(Open3).to receive(:popen3).with("raco test #{first_path} #{new_path}")
      stub_successful_run(new_paths) do
        instance.run(new_paths)
      end
    end
  end
end
