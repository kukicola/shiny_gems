# frozen_string_literal: true

RSpec.describe Processing::Workers::SyncAllWorker do
  let(:fake_gem_repo) { instance_double(Processing::Repositories::GemsRepository) }
  let(:fake_repos_repo) { instance_double(Processing::Repositories::ReposRepository) }

  subject { described_class.new(gems_repository: fake_gem_repo, repos_repository: fake_repos_repo).perform(1673908001) }

  before do
    allow(fake_gem_repo).to receive(:pluck_ids_for_hour).with(23).and_return([1,2,3])
    allow(fake_repos_repo).to receive(:pluck_ids_for_hour).with(23).and_return([5,6,7])
  end

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
