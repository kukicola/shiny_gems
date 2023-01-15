# frozen_string_literal: true

RSpec.describe Web::Views::Parts::Repo do
  let(:repo) { Factory.structs[:repo, stars: 34522342, name: "test/test"] }
  let(:instance) { described_class.new(value: repo) }

  describe "#stars" do
    it "returns formatted value" do
      expect(instance.stars).to eq("34,522,342")
    end
  end

  describe "#url" do
    it "returns formatted value" do
      expect(instance.url).to eq("https://github.com/test/test")
    end
  end
end
