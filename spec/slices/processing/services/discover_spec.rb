# frozen_string_literal: true

RSpec.describe Processing::Services::Discover do
  let(:fake_gems_repository) { fake_repository(:processing, :gems) }
  let(:fake_repos_repository) { fake_repository(:processing, :repos) }
  let(:fake_list_fetcher) { instance_double(Processing::Services::Rubygems::ListFetcher) }
  let(:instance) { described_class.new(list_fetcher: fake_list_fetcher, gems_repository: fake_gems_repository, repos_repository: fake_repos_repository) }

  subject { instance.call }

  context "no gems returned from API" do
    before { allow(fake_list_fetcher).to receive(:call).with(page: 1).and_return(Dry::Monads::Success([])) }

    it "returns failure" do
      expect(subject).to eq(Dry::Monads::Failure(:no_results))
    end
  end

  context "gems returned from API" do
    let(:existing_gem) { Factory.structs[:gem] }
    let(:existing_repo) { Factory.structs[:repo, name: "some/repo"] }
    let(:gems_list) do
      [
        {"name" => existing_gem.name, "homepage_uri" => "https://github.com/some/repo"},
        {"name" => "gem_with_existing_repo", "homepage_uri" => "https://github.com/some/repo"},
        {"name" => "new_gem_without_repo", "homepage_uri" => ""}
      ]
    end

    before do
      allow(fake_list_fetcher).to receive(:call).with(page: 1).and_return(Dry::Monads::Success(gems_list))
      allow(fake_gems_repository).to receive(:pluck_name_by_list).with([existing_gem.name, "gem_with_existing_repo", "new_gem_without_repo"])
        .and_return([existing_gem.name])
      allow(fake_gems_repository).to receive(:transaction).and_yield
      allow(fake_gems_repository).to receive(:create)
      allow(fake_repos_repository).to receive(:find_or_create).with({name: "some/repo"})
        .and_return(existing_repo)
      allow(fake_gems_repository).to receive(:create).with(hash_including(name: "gem_with_existing_repo", repo_id: existing_repo.id))
        .and_return(Factory.structs[:gem, name: "gem_with_existing_repo"])
    end

    it "ignores existing gem" do
      expect(fake_gems_repository).not_to receive(:create).with(hash_including(name: existing_gem.name))
      subject
    end

    it "creates missing gem" do
      expect(fake_gems_repository).to receive(:create).with(hash_including(name: "gem_with_existing_repo", repo_id: existing_repo.id))
      subject
    end

    it "ignores gem without repo" do
      expect(fake_gems_repository).not_to receive(:create).with(hash_including(name: "new_gem_without_repo"))
      subject
    end

    it "returns Success with list of created gems" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to match([having_attributes(name: "gem_with_existing_repo")])
    end
  end
end
