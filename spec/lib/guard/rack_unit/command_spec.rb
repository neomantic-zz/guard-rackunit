require 'spec_helper'

describe Guard::RackUnit::Command do

  it 'returns failure result when it is unsuccessful' do
    stub_failed_run do
      result = described_class.new.execute(['paths'])
      expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
    end
  end

  it "returns a success result when it is successful" do
    stub_successful_run do
      result = described_class.new.execute(['paths'])
      expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
    end
  end

  it "returns pending result if there are no are no paths" do
    result = described_class.new.execute([])
    expect(result).to be_instance_of Guard::RackUnit::RunResult::Pending
  end
end
