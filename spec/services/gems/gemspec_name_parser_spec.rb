# frozen_string_literal: true

RSpec.describe ShinyGems::Services::Gems::GemspecNameParser do
  subject { described_class.new.call(content) }

  context "content contains name" do
    let(:content) do
      "Gem::Specification.new do |spec|
        spec.name          = 'simplecov-review'
        spec.version       = SimpleCov::Formatter::ReviewFormatter::VERSION
        spec.authors       = ['Karol Bąk']
        spec.email         = ['kukicola@gmail.com']
      end"
    end

    it "returns gem name" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq("simplecov-review")
    end
  end

  context "content doesn't contain name" do
    let(:content) do
      "Gem::Specification.new do |spec|
        spec.version       = SimpleCov::Formatter::ReviewFormatter::VERSION
        spec.authors       = ['Karol Bąk']
        spec.email         = ['kukicola@gmail.com']
      end"
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:name_not_found_in_gemspec)
    end
  end

  context "content is not a valid ruby code" do
    let(:content) do
      "Gem::Specification.new do |spec|
        spec.version       = SimpleCov::Formatter::ReviewFormatter::VERSION
        spec.authors       = ['Karol Bąk']
        spec.email         = ['kukicola@gmail.com']
      e"
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gemspec_parse_failed)
    end
  end
end
