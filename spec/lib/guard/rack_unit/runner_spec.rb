require 'spec_helper'

describe Guard::RackUnit::Runner do

  # let(:instance){described_class.new}

  # describe 'running some paths' do

  #   context "success" do
  #     it "runs test with the given paths and returns a success result " do
  #       stub_successful_run do
  #         result = instance.run_on_paths(['some_paths/'])
  #         expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
  #       end
  #     end
  #   end

  #   context "failure" do
  #     it "runs test with the given paths and returns a failure result " do
  #       stub_failed_run do
  #         result = instance.run_on_paths(['some_paths/'])
  #         expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
  #       end
  #     end
  #   end

  #   it 'returns true when no paths have been supplied' do
  #     expect(instance.run_on_paths([])).to be_instance_of Guard::RackUnit::RunResult::Pending
  #   end

  #   it "issues a notification when it runs just some paths" do
  #     expect(Guard::UI).to receive(:info).with("Running: /paths/test.rkt, /paths/another.rkt", reset: true)
  #     stub_successful_run do
  #       instance.run_on_paths(['/paths/test.rkt', '/paths/another.rkt'])
  #     end
  #   end

  #   it "does not issue a notification when the path is empty" do
  #     expect(Guard::UI).to_not receive(:info)
  #     instance.run_on_paths([])
  #   end

  #   it "runs the old failed paths as well as the new ones" do
  #     pending
  #   end

  #   it "does not run duplicates when the new path exists in the failed paths" do
  #     pending
  #   end
  # end

  # describe 'running all paths' do

  #   context "without paths" do

  #     it 'does not issue a notification' do
  #       expect(Guard::UI).to_not receive(:info)
  #       instance.run_all
  #     end
  #   end

  #   context "with paths" do

  #     let(:instance) {described_class.new(test_directory: ['/tests'])}

  #     it "issues a notification" do

  #       expect(Guard::UI).to receive(:info).with("Resetting", reset: true)
  #       stub_successful_run do
  #         instance.run_all
  #       end
  #     end

  #     context "success" do
  #       it "returns a success result" do
  #         stub_successful_run do
  #           result = instance.run_all
  #           expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
  #         end
  #       end
  #     end

  #     context "failure" do
  #       it "returns a failure result" do
  #         stub_failed_run do
  #           result = instance.run_all
  #           expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
  #         end
  #       end
  #     end
  #   end
  # end
end
