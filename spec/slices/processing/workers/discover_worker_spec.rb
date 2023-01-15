# frozen_string_literal: true

RSpec.describe Processing::Workers::DiscoverWorker do
  let(:fake_discover) { instance_double(Processing::Services::Discover) }

  subject { described_class.new(discover: fake_discover).perform(1) }

  context "no_results failure" do
    before { allow(fake_discover).to receive(:call).and_return(Dry::Monads::Failure(:no_results)) }

    it "doesn't enqueue sync jobs" do
      subject

      expect(Processing::Workers::SyncWorker).not_to have_enqueued_sidekiq_job
      expect(Processing::Workers::SyncIssuesWorker).not_to have_enqueued_sidekiq_job
      expect(Processing::Workers::SyncRepoWorker).not_to have_enqueued_sidekiq_job
    end

    it "doesn't enqueue next page job" do
      subject

      expect(described_class).not_to have_enqueued_sidekiq_job
    end
  end

  context "gems returned by Discover" do
    let(:gem) { Factory.structs[:gem, id: 1, repo: Factory.structs[:repo, id: 5]] }

    before { allow(fake_discover).to receive(:call).and_return(Dry::Monads::Success[gem]) }

    it "enqueues sync jobs" do
      subject

      expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(1)
      expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(5)
      expect(Processing::Workers::SyncRepoWorker).to have_enqueued_sidekiq_job(5)
    end

    it "enqueues next page job" do
      subject

      expect(described_class).to have_enqueued_sidekiq_job(2)
    end
  end
end
