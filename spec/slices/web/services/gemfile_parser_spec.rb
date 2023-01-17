# frozen_string_literal: true

RSpec.describe Web::Services::GemfileParser do
  subject { described_class.new.call(content) }

  context "content is valid gemfile" do
    let(:content) do
      'source "https://rubygems.org"

       gem "hanami", "~> 2.0"
       gem "hanami-router", "~> 2.0"'
    end

    it "returns gems" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(["hanami", "hanami-router"])
    end
  end

  context "content is valid gemfile but empty" do
    let(:content) do
      'source "https://rubygems.org"'
    end

    it "returns gems" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:no_gems_in_gemfile)
    end
  end

  context "content is not a valid ruby code" do
    let(:content) do
      'source https://rubygems.org"

       gem "hanami", "~> 2.0"
       gem "hanami-router", "~> 2.0"'
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gemfile_parse_failed)
    end
  end
end
