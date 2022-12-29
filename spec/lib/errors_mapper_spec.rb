# frozen_string_literal: true

RSpec.describe ShinyGems::ErrorsMapper do
  it "returns human error for key" do
    expect(described_class.new.call(:gem_already_exists)).to eq("Gem already exists")
  end
end
