# frozen_string_literal: true

Processing::Slice.prepare(:octokit)

RSpec.describe Processing::Workers::SyncWorker do
  let(:fake_gem_repo) do
    fake_repository(:processing, :gems) do |repo|
      allow(repo).to receive(:by_id).with(1).and_return(gem)
    end
  end
  let(:fake_syncer) { instance_double(Processing::Services::Syncer) }
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
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Failure(Gems::GemError.new))
      expect { subject }.to raise_error(Gems::GemError)
    end
  end

  context "gem not found" do
    it "deletes gem" do
      expect(fake_syncer).to receive(:call).with(gem).and_return(Dry::Monads::Failure(Gems::NotFound.new))
      expect(fake_gem_repo).to receive(:delete).with(1)
      subject
    end
  end
end
