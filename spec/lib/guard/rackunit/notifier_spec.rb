require 'spec_helper'

describe Guard::RackUnit::Notifier do


  let(:valid_options) do
    {image: :pending, priority: 2}
  end

  it "notifies" do
    message = "A message!"
    expect(Guard::Notifier).to receive(:notify).with(message, {title: 'RackUnit Results'}.merge(valid_options))
    instance = described_class.new(message)
    instance.notify(valid_options)
  end
end
