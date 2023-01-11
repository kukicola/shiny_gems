# frozen_string_literal: true

Processing::Slice.prepare(:octokit)

RSpec.describe Processing::Workers::SyncIssuesWorker do
  let(:fake_gem_repo) do
    fake_repository(:processing, :gems) do |repo|
      allow(repo).to receive(:by_id).with(1, with: [:issues]).and_return(gem)
    end
  end
  let(:fake_syncer) { instance_double(Processing::Services::IssuesSyncer) }
  let(:gem) { Factory.structs[:gem, :with_issues] }

  subject { described_class.new(gems_repository: fake_gem_repo, issues_syncer: fake_syncer).perform(1) }

  context "update successful" do
    it "calls sync" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Success())
      subject
    end
  end

  context "update failed" do
    it "raises error" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Failure(Octokit::Forbidden.new))
      expect { subject }.to raise_error(Octokit::Forbidden)
    end
  end
end
