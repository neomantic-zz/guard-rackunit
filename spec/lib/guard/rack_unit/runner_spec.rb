require 'spec_helper'

describe Guard::RackUnit::Runner do

  let(:instance){described_class.new}
  let(:test_path){test_path}

  context 'some paths' do
    it "runs test with the given paths" do
      pending
    end

    it 'returns true' do
      expect(instance.run_on_paths([])).to be_true
    end

    it "issues a notification when it runs just some paths" do
      expect(Guard::UI).to receive(:info).with("Running: /paths/test.rkt, /paths/another.rkt", reset: true)
      instance.run_on_paths(['/paths/test.rkt', '/paths/another.rkt'])
    end

    it "does not issue a notification when the path is empty" do
      expect(Guard::UI).to_not receive(:info)
      instance.run_on_paths([])
    end
  end

  context 'all paths' do
    it "returns true when not pass were test_directory is not set" do
      expect(instance.run_all).to be_true
    end

    it "does not issue a notification when the test_directory is not set" do
      expect(Guard::UI).to_not receive(:info)
      instance.run_all
    end

    it "issues a notification when it runs all paths" do
      instance = described_class.new(test_directory: ['/tests'])
      expect(Guard::UI).to receive(:info).with("Resetting", reset: true)
      instance.run_all
    end

    it "runs all the failed paths with the new paths" do
      pending
    end
  end
end
