# frozen_string_literal: true

RSpec.describe Web::Views::Parts::Gem do
  let(:gem) { Factory.structs[:gem, downloads: 34522342, name: "test"] }
  let(:instance) { described_class.new(value: gem) }

  describe "#downloads" do
    it "returns formatted value" do
      expect(instance.downloads).to eq("34,522,342")
    end
  end

  describe "#url" do
    it "returns formatted value" do
      expect(instance.url).to eq("https://rubygems.org/gems/test")
    end
  end
end
