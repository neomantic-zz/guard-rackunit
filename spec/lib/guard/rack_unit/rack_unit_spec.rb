require 'spec_helper'

describe Guard::RackUnit do
  it "is a plugin" do
    expect(described_class.new).to be_kind_of Guard::Plugin
  end
end
