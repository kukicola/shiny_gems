# frozen_string_literal: true

RSpec.describe Processing::Workers::SyncAllWorker do
  let(:fake_gem_repo) { instance_double(Processing::Repositories::GemsRepository, pluck_ids: [1, 2, 3]) }

  subject { described_class.new(gems_repository: fake_gem_repo).perform }

  it "schedules single sync jobs" do
    subject
    expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(1)
    expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(2)
    expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(3)
    expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(1)
    expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(2)
    expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(3)
  end
end
