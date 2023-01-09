# frozen_string_literal: true

Processing::Slice.prepare(:gems_api)

RSpec.describe Processing::Services::Rubygems::ListFetcher do
  subject { described_class.new(gems_api: fake_gem_api).call(page: 2) }

  let(:fake_gem_api) { class_double(::Gems) }

  context "API returned data" do
    before { allow(fake_gem_api).to receive(:search).with("downloads:>1000000", { page: 2 }).and_return({"some" => "data"}) }

    it "returns data from API" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq({"some" => "data"})
    end
  end

  context "API returned error" do
    before { allow(fake_gem_api).to receive(:search).with("downloads:>1000000", { page: 2 }).and_raise(::Gems::NotFound) }

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gem_list_fetch_failed)
    end
  end
end
