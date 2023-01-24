# frozen_string_literal: true

RSpec.describe Processing::Services::RepoSyncer do
  let(:fake_repo_fetcher) { instance_double(Processing::Services::Github::RepoFetcher) }
  let(:fake_repos_repository) { instance_double(Processing::Repositories::ReposRepository) }
  let(:fake_gems_repository) { instance_double(Processing::Repositories::GemsRepository) }
  let(:repo) { Factory.structs[:repo, name: "some/some_gem"] }

  subject do
    described_class.new(
      repo_fetcher: fake_repo_fetcher,
      repos_repository: fake_repos_repository,
      gems_repository: fake_gems_repository
    ).call(repo)
  end

  context "one of services returns failure" do
    before do
      allow(fake_repo_fetcher).to receive(:call).with("some/some_gem").and_return(Dry::Monads::Failure(:error))
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:error)
    end
  end

  context "repo name didn't change" do
    let(:github_info) do
      {
        stargazers_count: 50000,
        full_name: "some/some_gem",
        pushed_at: DateTime.new(2022, 12, 12, 12, 0, 0)
      }
    end
    let(:expected_attributes) do
      {
        stars: 50000,
        pushed_at: DateTime.new(2022, 12, 12, 12, 0, 0)
      }
    end

    before do
      allow(fake_repo_fetcher).to receive(:call).with("some/some_gem").and_return(Dry::Monads::Success(github_info))
      allow(fake_repos_repository).to receive(:update).with(repo.id, expected_attributes).and_return(repo)
    end

    it "returns saved repo" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(repo)
    end
  end

  context "repo name changed" do
    let(:existing_repo) { Factory.structs[:repo, name: "new/some_gem"] }
    let(:github_info) do
      {
        stargazers_count: 50000,
        full_name: "new/some_gem",
        pushed_at: DateTime.new(2022, 12, 12, 12, 0, 0)
      }
    end
    let(:expected_attributes) do
      {
        stars: 50000,
        pushed_at: DateTime.new(2022, 12, 12, 12, 0, 0)
      }
    end

    before do
      allow(fake_repo_fetcher).to receive(:call).with("some/some_gem").and_return(Dry::Monads::Success(github_info))
      allow(fake_repos_repository).to receive(:transaction).and_yield
    end

    it "replaces old repo with new one and returns new one" do
      expect(fake_repos_repository).to receive(:find_or_create).with({name: "new/some_gem"}).and_return(existing_repo)
      expect(fake_gems_repository).to receive(:replace_repo).with(repo.id, existing_repo.id)
      expect(fake_repos_repository).to receive(:delete).with(repo.id)
      expect(fake_repos_repository).to receive(:update).with(existing_repo.id, expected_attributes).and_return(existing_repo)

      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(existing_repo)
    end
  end
end
