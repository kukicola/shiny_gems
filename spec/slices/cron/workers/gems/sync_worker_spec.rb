# frozen_string_literal: true

RSpec.describe Cron::Workers::Gems::SyncWorker do
  let(:fake_gem_repo) do
    fake_repository(:gems) do |repo|
      allow(repo).to receive(:by_id).with(1).and_return(gem)
    end
  end
  let(:fake_syncer) { instance_double(Core::Services::Gems::Syncer) }
  let(:gem) { Factory.structs[:gem] }

  subject { described_class.new(gems_repository: fake_gem_repo, syncer: fake_syncer).perform(1) }

  context "sync successful" do
    it "calls sync" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Success())
      subject
    end
  end

  context "sync failed" do
    it "raises error" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Failure(:abc))
      expect { subject }.to raise_error(Cron::Workers::Gems::SyncWorker::SyncError, "abc")
    end
  end
end
