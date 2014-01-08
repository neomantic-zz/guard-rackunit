require 'spec_helper'

describe Guard::RackUnit::Command do

  it 'returns failure result when it is unsuccessful' do
    status = double(Process::Status, :success? => false)
    process = double('wait_thr', pid: 1, value: status)
    Open3.stub(:popen3).and_yield(StringIO.new(''), StringIO.new(''), StringIO.new(''), process)
    result = described_class.new.execute(['paths'])
    expect(result).to be_instance_of Guard::RackUnit::RunResult::Failure
  end

  it "returns a success result when it is successful" do
    status = double(Process::Status, :success? => true)
    process = double('wait_thr', pid: 1, value: status)
    Open3.stub(:popen3).and_yield(StringIO.new(''), StringIO.new(''), StringIO.new(''), process)
    result = described_class.new.execute(['paths'])
    expect(result).to be_instance_of Guard::RackUnit::RunResult::Success
  end

  it "returns pending result if there are no are no paths" do
    result = described_class.new.execute([])
    expect(result).to be_instance_of Guard::RackUnit::RunResult::Pending
  end
end
