# frozen_string_literal: true

RSpec.describe Processing::Services::RepoSyncer do
  let(:fake_repo_fetcher) { instance_double(Processing::Services::Github::RepoFetcher) }
  let(:fake_repos_repository) { instance_double(Processing::Repositories::ReposRepository) }
  let(:repo) { Factory.structs[:repo, name: "some/some_gem"] }
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
      name: "new/some_gem",
      pushed_at: DateTime.new(2022, 12, 12, 12, 0, 0)
    }
  end

  subject do
    described_class.new(
      repo_fetcher: fake_repo_fetcher,
      repos_repository: fake_repos_repository
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

  context "everything goes ok" do
    before do
      allow(fake_repo_fetcher).to receive(:call).with("some/some_gem").and_return(Dry::Monads::Success(github_info))
      allow(fake_repos_repository).to receive(:update).with(repo.id, expected_attributes).and_return(repo)
    end

    it "returns saved gem" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(repo)
    end
  end
end
