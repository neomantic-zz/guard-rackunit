require 'spec_helper'

describe Guard::RackUnit::RunResult do

  context 'success' do
    it "returns a result" do
      stub_successful_run do |out, err, _|
        result = described_class.create(out, err)
        expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
      end
    end
  end

  context 'failure' do
    it "returns a result" do
      stub_failed_run do |out, err, _|
        result = described_class.create(out,err)
        expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
      end
    end

    context "when there are successes too, but a runtime failure" do

      it "returns a failure result" do
        with_successful_stdout do |stdout|
          with_failed_stderr('/samples/runtime_error') do |stderr|
            stub_run(stdout, stderr)
            result = described_class.create(stdout, stderr)
            expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
          end
        end
      end

      it "prints both the stdout and stderr" do
        with_successful_stdout do |stdout|
          with_failed_stderr('/samples/runtime_error') do |stderr|
            stub_run(stdout, stderr)
            expected = stdout.read
            stdout.rewind
            expected << stderr.read
            stderr.rewind
            result = capture_stdout do
              described_class.create(stdout,stderr)
            end
            expect(result).to eq expected
          end
        end
      end
    end
  end

  describe Guard::RackUnit::RunResult::Pending do
    let(:instance){Guard::RackUnit::RunResult::Pending.new}
    it 'returns an empty set of paths' do
      expect(instance.paths).to be_instance_of Set
      expect(instance.paths).to be_empty
    end

    it "issue notifications that do nothing" do
      expect(Guard::Notifier).to_not receive(:notify)
      instance.issue_notification
    end

    it "return false for successful" do
      expect(instance.successful?).to be_false
    end
  end

  describe Guard::RackUnit::RunResult::Success do
    it "returns a set of empty paths" do
      with_successful_stdout do |out|
        result = Guard::RackUnit::RunResult::Success.new out
        expect(result.paths).to be_instance_of Set
        expect(result.paths).to be_empty
      end
    end

    it "returns true for successful" do
      with_successful_stdout do |out|
        result = Guard::RackUnit::RunResult::Success.new out
        expect(result.successful?).to be_true
      end
    end

    it "issues the correct notification message" do
      success =<<SUCCESS
raco test: (submod "tests/vm-tests.rkt" test)
8 tests passed
SUCCESS
      result = Guard::RackUnit::RunResult::Success.new StringIO.new(success)
      expect(Guard::Notifier).to receive(:notify).with("8 tests passed", {title: 'RackUnit Results', image: :success, priority: -2})
      result.issue_notification
    end

    it "issues a default notification message when there is no content in stdout" do
      result = Guard::RackUnit::RunResult::Success.new StringIO.new('')
      expect(Guard::Notifier).to receive(:notify).with("Success", {title: 'RackUnit Results', image: :success, priority: -2})
      result.issue_notification
    end


    it "outputs the stdout" do
      expected = 'expected'
      result = 'not expected'
      with_successful_stdout do |out|
        expected = out.read # read it to build the expectation
        out.rewind
        result = capture_stdout do
          Guard::RackUnit::RunResult::Success.new out
        end
      end
      expect(result).to eq expected
    end
  end

  describe Guard::RackUnit::RunResult::Failure do

    it "returns a populated set of failed paths" do
      with_failed_stderr do |err|
        result = Guard::RackUnit::RunResult::Failure.new(err)
        expect(result.paths).to be_instance_of Set
        expect(result.paths).to_not be_empty
      end
    end

    it "returns false for successful" do
      with_failed_stderr do |err|
        result = Guard::RackUnit::RunResult::Failure.new(err)
        expect(result.successful?).to be_false
      end
    end


    it "retrieves the correct failed paths" do
      failure =<<FAIL
--------------------
parsing: """
FAILURE
message:    "No exception raised"
name:       check-exn
location:   (#<path:/home/test-user/racket-project/tests/sample-tests.rkt> 19 4 389 113)
expression: (check-exn exn:fail:parsack? (lambda () (parsack-parse string)))
params:     (#<procedure:exn:fail:parsack?> #<procedure:temp6>)

Check failure
--------------------
1/101 test failures
FAIL
      result = Guard::RackUnit::RunResult::Failure.new(StringIO.new(failure))
      expect(result.paths).to include '/home/test-user/racket-project/tests/sample-tests.rkt'
    end

    it "outputs the stderr" do
      expected = 'expected'
      result = 'not expected'
      with_failed_stderr do |err|
        expected = err.read # read it to build the expectation
        err.rewind
        result = capture_stdout do
          Guard::RackUnit::RunResult::Failure.new(err)
        end
      end
      expect(result).to eq expected
    end

    it "issues a notification with the correct message when it's simple" do
      failure =<<FAIL
--------------------
parsing: """
FAILURE
message:    "No exception raised"
name:       check-exn
location:   (#<path:/home/test-user/racket-project/tests/sample-tests.rkt> 19 4 389 113)
expression: (check-exn exn:fail:parsack? (lambda () (parsack-parse string)))
params:     (#<procedure:exn:fail:parsack?> #<procedure:temp6>)

Check failure
--------------------
1/101 test failures
FAIL
      result = Guard::RackUnit::RunResult::Failure.new(StringIO.new(failure))
      expect(Guard::Notifier).to receive(:notify).with("1/101 test failures", {title: 'RackUnit Results', image: :failed, priority: 2})
      result.issue_notification
    end

    it "issues a notification with default message if stderr is empty" do
      result = Guard::RackUnit::RunResult::Failure.new(StringIO.new(''))
      expect(Guard::Notifier).to receive(:notify).with("Failed", {title: 'RackUnit Results', image: :failed, priority: 2})
      result.issue_notification
    end

    it "issues a notification with a message when hit hits an exception" do
      stdout =<<FAILED
--------------------
creates an assembly s-expression
ERROR
this is an error
  context...:
   /home/calbers/src/mine/scheme-assembler/evaluator.rkt:50:0: parsed-sexp->sexp-assembly
   /home/calbers/src/mine/scheme-assembler/tests/evaluator-tests.rkt: [running body]
   /usr/share/racket/collects/compiler/commands/test.rkt:29:10: for-loop
   f8
   /usr/share/racket/collects/compiler/commands/test.rkt: [running body]
   /usr/share/racket/collects/raco/raco.rkt: [running body]
   /usr/share/racket/collects/raco/main.rkt: [running body]

--------------------
FAILED
      result = Guard::RackUnit::RunResult::Failure.new(StringIO.new(stdout))
      expect(Guard::Notifier).to receive(:notify).
        with("ERROR: /home/calbers/src/mine/scheme-assembler/evaluator.rkt:50:0: parsed-sexp->sexp-assembly",
             {title: 'RackUnit Results', image: :failed, priority: 2})
      result.issue_notification
    end
  end
end
