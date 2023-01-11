# frozen_string_literal: true

RSpec.describe Web::ErrorsMapper do
  it "returns human error for key" do
    expect(described_class.new.call(:gemfile_parse_failed)).to eq("Couldn't parse gemfile")
  end
end
