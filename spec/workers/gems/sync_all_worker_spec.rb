# frozen_string_literal: true

RSpec.describe ShinyGems::Workers::Gems::SyncAllWorker do
  let(:fake_gem_repo) { instance_double(ShinyGems::Repositories::GemsRepository, pluck_ids: [1, 2, 3]) }

  subject { described_class.new(gems_repository: fake_gem_repo).perform }

  it "schedules single sync jobs" do
    subject
    expect(ShinyGems::Workers::Gems::SyncWorker).to have_enqueued_sidekiq_job(1)
    expect(ShinyGems::Workers::Gems::SyncWorker).to have_enqueued_sidekiq_job(2)
    expect(ShinyGems::Workers::Gems::SyncWorker).to have_enqueued_sidekiq_job(3)
    expect(ShinyGems::Workers::Gems::SyncIssuesWorker).to have_enqueued_sidekiq_job(1)
    expect(ShinyGems::Workers::Gems::SyncIssuesWorker).to have_enqueued_sidekiq_job(2)
    expect(ShinyGems::Workers::Gems::SyncIssuesWorker).to have_enqueued_sidekiq_job(3)
  end
end
