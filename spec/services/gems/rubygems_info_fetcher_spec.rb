# frozen_string_literal: true

Hanami.app.prepare(:gems_api)

RSpec.describe ShinyGems::Services::Gems::RubygemsInfoFetcher do
  subject { described_class.new(gems_api: fake_gem_api).call("some_gem") }

  let(:fake_gem_api) { class_double(::Gems) }

  context "API returned data" do
    before { allow(fake_gem_api).to receive(:info).with("some_gem").and_return({"some" => "data"}) }

    it "returns data from API" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq({"some" => "data"})
    end
  end

  context "API returned error" do
    before { allow(fake_gem_api).to receive(:info).with("some_gem").and_raise(::Gems::NotFound) }

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gem_info_fetch_failed)
    end
  end
end
