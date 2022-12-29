# frozen_string_literal: true

RSpec.describe ShinyGems::Formatter do
  let(:instance) { described_class.new }

  describe "#separator" do
    it "returns number with separators" do
      expect(instance.separator(2342315)).to eq("2,342,315")
    end
  end
end
