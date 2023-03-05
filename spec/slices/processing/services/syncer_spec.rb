# frozen_string_literal: true

RSpec.describe Processing::Services::Syncer do
  let(:fake_rubygems_fetcher) { instance_double(Processing::Services::Rubygems::GemFetcher) }
  let(:fake_gem_repo) { instance_double(Processing::Repositories::GemsRepository) }
  let(:gem) { Factory.structs[:gem, name: "some_gem"] }
  let(:gem_info) do
    {
      "name" => "some_gem",
      "info" => "some description",
      "downloads" => 50000,
      "homepage_uri" => "https://github.com/test/some_gem",
      "version" => "2.0.0",
      "licenses" => ["MIT"]
    }
  end
  let(:expected_attributes) do
    {
      description: "some description",
      downloads: 50000,
      licenses: ["MIT"],
      version: "2.0.0"
    }
  end

  subject do
    described_class.new(
      gem_fetcher: fake_rubygems_fetcher,
      gems_repository: fake_gem_repo
    ).call(gem)
  end

  context "one of services returns failure" do
    before do
      allow(fake_rubygems_fetcher).to receive(:call).with("some_gem").and_return(Dry::Monads::Failure(:gem_info_fetch_failed))
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gem_info_fetch_failed)
    end
  end

  context "everything goes ok" do
    before do
      allow(fake_rubygems_fetcher).to receive(:call).with("some_gem").and_return(Dry::Monads::Success(gem_info))
      allow(fake_gem_repo).to receive(:update).with(gem.id, expected_attributes).and_return(gem)
    end

    it "returns saved gem" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(gem)
    end
  end
end
