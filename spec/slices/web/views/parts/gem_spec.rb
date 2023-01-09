# frozen_string_literal: true

RSpec.describe Web::Views::Parts::Gem do
  let(:gem) { Factory.structs[:gem, stars: 34522342, downloads: 2312] }
  let(:instance) { described_class.new(value: gem) }

  describe "#stars" do
    it "returns formatted value" do
      expect(instance.stars).to eq("34,522,342")
    end
  end

  describe "#downloads" do
    it "returns formatted value" do
      expect(instance.downloads).to eq("2,312")
    end
  end
end
