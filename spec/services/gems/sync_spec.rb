# frozen_string_literal: true

RSpec.describe ShinyGems::Services::Gems::Sync do
  let(:fake_rubygems_info) { instance_double(ShinyGems::Services::Gems::RubygemsInfo) }
  let(:fake_repo) { instance_double(ShinyGems::Services::Github::Repo) }
  let(:fake_gem_repo) { instance_double(ShinyGems::Repositories::GemsRepository) }
  let(:gem) { Factory.structs[:gem, name: "some_gem", repo: "test/some_gem"] }
  let(:repo_data) do
    {full_name: "test/some_gem", stargazers_count: 50}
  end
  let(:gem_info) do
    {
      "name" => "some_gem",
      "info" => "some description",
      "downloads" => 50000,
      "homepage_uri" => "https://github.com/test/some_gem"
    }
  end
  let(:expected_attributes) do
    {
      description: "some description",
      stars: 50,
      downloads: 50000
    }
  end

  subject do
    described_class.new(
      rubygems_info: fake_rubygems_info,
      repo: fake_repo,
      gems_repository: fake_gem_repo
    ).call(gem)
  end

  context "one of services returns failure" do
    before do
      allow(fake_repo).to receive(:call).with("test/some_gem").and_return(Dry::Monads::Success(repo_data))
      allow(fake_rubygems_info).to receive(:call).with("some_gem").and_return(Dry::Monads::Failure(:gem_info_fetch_failed))
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gem_info_fetch_failed)
    end
  end

  context "everything goes ok" do
    before do
      allow(fake_repo).to receive(:call).with("test/some_gem").and_return(Dry::Monads::Success(repo_data))
      allow(fake_rubygems_info).to receive(:call).with("some_gem").and_return(Dry::Monads::Success(gem_info))
      allow(fake_gem_repo).to receive(:update).with(gem.id, expected_attributes).and_return(gem)
    end

    it "returns saved gem" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(gem)
    end
  end
end
