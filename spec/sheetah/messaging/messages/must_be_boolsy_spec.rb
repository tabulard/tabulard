# frozen_string_literal: true

require "sheetah/messaging/messages/must_be_boolsy"

RSpec.describe Sheetah::Messaging::Messages::MustBeBoolsy do
  it "has a default code" do
    expect(described_class.new).to have_attributes(code: described_class::CODE)
  end
end
