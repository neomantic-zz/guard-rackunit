require 'spec_helper'

describe Guard::RackUnit do
  it "is a plugin" do
    expect(described_class.new).to be_kind_of Guard::Plugin
  end

  it "runs all on start when that option is set" do
    pending
  end

  it "notifies the user that it has started" do
    pending
  end

  describe "run_all" do
    it "returns a success result on success" do
      pending
    end
    it "returns a failure result on failure" do
      pending
    end
  end

  describe "start" do
    it "returns a success result on success" do
      pending
    end
    it "returns a failure result on failure" do
      pending
    end
  end

  describe "running on modifications" do
    it "returns a success result on success" do
      pending
    end
    it "returns a failure result on failure" do
      pending
    end
  end
end
