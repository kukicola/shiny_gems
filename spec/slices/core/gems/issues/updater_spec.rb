# frozen_string_literal: true

RSpec.describe Core::Services::Gems::Issues::Updater do
  let(:fake_issues_repository) do
    fake_repository(:issues) do |repo|
      allow(repo).to receive(:transaction).and_yield
      allow(repo).to receive(:update).with(any_args)
      allow(repo).to receive(:delete).with(any_args)
      allow(repo).to receive(:create).with(any_args)
    end
  end

  let!(:existing_issue1) { Factory.structs[:issue, github_id: 100] }
  let!(:existing_issue2) { Factory.structs[:issue, github_id: 101] }
  let!(:existing_issue3) { Factory.structs[:issue, github_id: 102] }
  let(:fake_issues_list_fetcher) { instance_double(Core::Services::Github::IssuesListFetcher) }
  let(:gem) { Factory.structs[:gem, :with_issues, issues: [existing_issue1, existing_issue2, existing_issue3]] }
  let(:issues_ids) { [100, 101, 103] }
  let(:fake_gh_list) do
    [
      {id: 100, title: "Issue1", comments: 5, html_url: "repo/issues/1", state: "open", labels: [{name: "test", color: "324532"}]},
      {id: 101, title: "Issue2", comments: 53, html_url: "repo/issues/2", state: "closed", labels: []},
      {id: 102, title: "Issue3", comments: 52, html_url: "repo/issues/3", state: "open", labels: []},
      {id: 103, title: "Issue4", comments: 65, html_url: "repo/issues/4", state: "open", labels: []}
    ]
  end

  before do
    allow(fake_issues_list_fetcher).to receive(:call).with(gem.repo, all: true).and_return(Dry::Monads::Success(fake_gh_list))
  end

  subject do
    described_class.new(issues_list_fetcher: fake_issues_list_fetcher, issues_repository: fake_issues_repository)
      .call(gem: gem, issues_ids: issues_ids)
  end

  it "returns success" do
    expect(subject.success?).to be_truthy
  end

  it "removes closed issues" do
    expect(fake_issues_repository).to receive(:delete).with(existing_issue2.id)
    subject
  end

  it "removes issues not on the list" do
    expect(fake_issues_repository).to receive(:delete).with(existing_issue3.id)
    subject
  end

  it "updates open issues on the list" do
    expect(fake_issues_repository).to receive(:update).with(existing_issue1.id, {
      title: "Issue1",
      comments: 5,
      url: "repo/issues/1",
      github_id: 100,
      labels: [{name: "test", color: "324532"}]
    })
    subject
  end

  it "creates open issues on the list when not present in DB" do
    expect(fake_issues_repository).to receive(:create).with({
      title: "Issue4",
      comments: 65,
      url: "repo/issues/4",
      gem_id: gem.id,
      github_id: 103,
      labels: []
    })
    subject
  end
end
