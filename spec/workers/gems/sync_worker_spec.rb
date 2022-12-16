# frozen_string_literal: true

RSpec.describe ShinyGems::Workers::Gems::SyncWorker do
  let(:fake_gem_repo) { instance_double(ShinyGems::Repositories::GemsRepository, pluck_ids: [1, 2, 3]) }
  let(:fake_syncer) { instance_double(ShinyGems::Services::Gems::Syncer) }
  let(:gem) { Factory.structs[:gem] }

  subject { described_class.new(gems_repository: fake_gem_repo, syncer: fake_syncer).perform(1) }

  context "sync successful" do
    before do
      allow(fake_gem_repo).to receive(:by_id).with(1).and_return(gem)
    end

    it "calls sync" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Success())
      subject
    end
  end

  context "sync failed" do
    before do
      allow(fake_gem_repo).to receive(:by_id).with(1).and_return(gem)
    end

    it "raises error" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Failure(:abc))
      expect { subject }.to raise_error(ShinyGems::Workers::Gems::SyncWorker::SyncError, "abc")
    end
  end
end
