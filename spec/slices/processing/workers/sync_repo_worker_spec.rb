# frozen_string_literal: true

Processing::Slice.prepare(:octokit)

RSpec.describe Processing::Workers::SyncRepoWorker do
  let(:fake_repos_repository) do
    fake_repository(:processing, :repos) do |repository|
      allow(repository).to receive(:by_id).with(1).and_return(repo)
    end
  end
  let(:fake_syncer) { instance_double(Processing::Services::RepoSyncer) }
  let(:repo) { Factory.structs[:repo] }

  subject { described_class.new(repos_repository: fake_repos_repository, repo_syncer: fake_syncer).perform(1) }

  context "sync successful" do
    it "calls sync" do
      expect(fake_syncer).to receive(:call).with(repo).and_return(Dry::Monads::Success())
      subject
    end
  end

  context "sync failed" do
    it "raises error" do
      expect(fake_syncer).to receive(:call).with(repo).and_return(Dry::Monads::Failure(Octokit::Forbidden.new))
      expect { subject }.to raise_error(Octokit::Forbidden)
    end
  end
end
