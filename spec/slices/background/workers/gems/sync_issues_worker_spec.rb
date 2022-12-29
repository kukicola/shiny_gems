# frozen_string_literal: true

RSpec.describe Background::Workers::Gems::SyncIssuesWorker do
  let(:fake_gem_repo) do
    fake_repository(:gems) do |repo|
      allow(repo).to receive(:by_id).with(1, with: [:issues]).and_return(gem)
    end
  end
  let(:fake_updater) { instance_double(Core::Services::Gems::Issues::Updater) }
  let!(:existing_issue1) { Factory.structs[:issue, github_id: 100] }
  let!(:existing_issue2) { Factory.structs[:issue, github_id: 101] }
  let!(:existing_issue3) { Factory.structs[:issue, github_id: 102] }
  let(:gem) { Factory.structs[:gem, :with_issues, issues: [existing_issue1, existing_issue2, existing_issue3]] }
  let(:issues_ids) { [100, 101, 102] }

  subject { described_class.new(gems_repository: fake_gem_repo, updater: fake_updater).perform(1) }

  context "update successful" do
    it "calls sync" do
      expect(fake_updater).to receive(:call).with(gem: gem, issues_ids: issues_ids).and_return(Dry::Monads::Success())
      subject
    end
  end

  context "update failed" do
    it "raises error" do
      expect(fake_updater).to receive(:call).with(gem: gem, issues_ids: issues_ids).and_return(Dry::Monads::Failure(:abc))
      expect { subject }.to raise_error(Background::Workers::Gems::SyncIssuesWorker::SyncError, "abc")
    end
  end
end
