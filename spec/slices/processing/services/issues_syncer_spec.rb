# frozen_string_literal: true

RSpec.describe Processing::Services::IssuesSyncer do
  let(:fake_issues_repository) do
    fake_repository(:processing, :issues) do |repository|
      allow(repository).to receive(:transaction).and_yield
      allow(repository).to receive(:update).with(any_args)
      allow(repository).to receive(:delete).with(any_args)
      allow(repository).to receive(:create).with(any_args)
    end
  end

  let!(:existing_issue1) { Factory.structs[:issue, github_id: 100] }
  let!(:existing_issue2) { Factory.structs[:issue, github_id: 101] }
  let(:fake_issues_list_fetcher) { instance_double(Processing::Services::Github::IssuesListFetcher) }
  let(:repo) { Factory.structs[:repo, issues: [existing_issue1, existing_issue2]] }
  let(:fake_gh_list) do
    [
      {
        id: 100,
        title: "Issue1",
        comments: 5,
        html_url: "repo/issues/1",
        created_at: DateTime.new(2011, 4, 22, 13, 33, 48, 0),
        labels: [{name: "test", color: "324532"}]
      },
      {
        id: 103,
        title: "Issue4",
        comments: 65,
        html_url: "repo/issues/4",
        created_at: DateTime.new(2011, 4, 22, 13, 33, 48, 0),
        labels: []
      }
    ]
  end

  before do
    allow(fake_issues_list_fetcher).to receive(:call).with(repo.name).and_return(Dry::Monads::Success(fake_gh_list))
  end

  subject do
    described_class.new(issues_list_fetcher: fake_issues_list_fetcher, issues_repository: fake_issues_repository).call(repo)
  end

  it "returns success" do
    expect(subject.success?).to be_truthy
  end

  it "removes closed issues" do
    expect(fake_issues_repository).to receive(:delete).with(existing_issue2.id)
    subject
  end

  it "updates open issues on the list" do
    expect(fake_issues_repository).to receive(:update).with(existing_issue1.id, {
      title: "Issue1",
      comments: 5,
      url: "repo/issues/1",
      github_id: 100,
      created_at: DateTime.new(2011, 4, 22, 13, 33, 48, 0),
      labels: [{name: "test", color: "324532"}]
    })
    subject
  end

  it "creates open issues on the list when not present in DB" do
    expect(fake_issues_repository).to receive(:create).with({
      title: "Issue4",
      comments: 65,
      url: "repo/issues/4",
      repo_id: repo.id,
      github_id: 103,
      created_at: DateTime.new(2011, 4, 22, 13, 33, 48, 0),
      labels: []
    })
    subject
  end
end
