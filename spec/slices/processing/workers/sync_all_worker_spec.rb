# frozen_string_literal: true

RSpec.describe Processing::Workers::SyncAllWorker do
  let(:fake_gem_repo) { instance_double(Processing::Repositories::GemsRepository, pluck_ids: [1, 2, 3]) }
  let(:fake_repos_repo) { instance_double(Processing::Repositories::ReposRepository, pluck_ids: [5, 6, 7]) }

  subject { described_class.new(gems_repository: fake_gem_repo, repos_repository: fake_repos_repo).perform }

  it "schedules single sync jobs" do
    subject
    expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(1)
    expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(2)
    expect(Processing::Workers::SyncWorker).to have_enqueued_sidekiq_job(3)
    expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(5)
    expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(6)
    expect(Processing::Workers::SyncIssuesWorker).to have_enqueued_sidekiq_job(7)
    expect(Processing::Workers::SyncRepoWorker).to have_enqueued_sidekiq_job(5)
    expect(Processing::Workers::SyncRepoWorker).to have_enqueued_sidekiq_job(6)
    expect(Processing::Workers::SyncRepoWorker).to have_enqueued_sidekiq_job(7)
  end
end
