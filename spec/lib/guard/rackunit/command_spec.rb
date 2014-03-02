require 'spec_helper'

describe Guard::RackUnit::Command do

  let(:instance){described_class.new}

  it 'returns failure result when it is unsuccessful' do
    stub_failed_run do
      expect(instance.execute(['paths'])).
        to be_instance_of Guard::RackUnit::RunResult::Failure
    end
  end

  it "returns a success result when it is successful" do
    stub_successful_run do
      expect(instance.execute(['paths'])).
        to be_instance_of Guard::RackUnit::RunResult::Success
    end
  end

  it "returns pending result if there are no are no paths" do
    expect(instance.execute([])).to be_instance_of Guard::RackUnit::RunResult::Pending
  end

  it "runs the correct command" do
    expect(Open3).to receive(:popen3).with("raco test paths1 paths2")
    instance.execute(['paths1', 'paths2'])
  end
end
