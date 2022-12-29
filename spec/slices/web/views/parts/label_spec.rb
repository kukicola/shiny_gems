# frozen_string_literal: true

RSpec.describe Web::Views::Parts::Label do
  let(:label_light) { {"name" => "test", "color" => "dddddd"} }
  let(:label_dark) { {"name" => "dark", "color" => "222222"} }
  let(:instance_light) { described_class.new(value: label_light) }
  let(:instance_dark) { described_class.new(value: label_dark) }

  describe "#name" do
    it "returns name" do
      expect(instance_light.name).to eq("test")
      expect(instance_dark.name).to eq("dark")
    end
  end

  describe "#bg_color" do
    it "returns formatter color" do
      expect(instance_light.bg_color).to eq("#dddddd")
      expect(instance_dark.bg_color).to eq("#222222")
    end
  end

  describe "#bg_light?" do
    it "returns if color is light" do
      expect(instance_light.bg_light?).to be_truthy
      expect(instance_dark.bg_light?).to be_falsey
    end
  end
end
