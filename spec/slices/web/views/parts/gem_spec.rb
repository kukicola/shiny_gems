# frozen_string_literal: true

RSpec.describe Web::Views::Parts::Gem do
  let(:gem) { Factory.structs[:gem, downloads: 34522342] }
  let(:instance) { described_class.new(value: gem) }

  describe "#downloads" do
    it "returns formatted value" do
      expect(instance.downloads).to eq("34,522,342")
    end
  end
end
