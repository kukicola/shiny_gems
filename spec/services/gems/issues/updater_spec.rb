# frozen_string_literal: true

RSpec.describe ShinyGems::Services::Gems::Issues::Updater, type: :database do
  let(:gems_repo) { ShinyGems::Repositories::GemsRepository.new }
  let(:issues_relation) { Hanami.app["persistence.rom"].relations[:issues] }
  let!(:existing_issue1) { Factory[:issue, gem: gem, github_id: 100] }
  let!(:existing_issue2) { Factory[:issue, gem: gem, github_id: 101] }
  let!(:existing_issue3) { Factory[:issue, gem: gem, github_id: 102] }
  let(:fake_issues_list_fetcher) { instance_double(ShinyGems::Services::Github::IssuesListFetcher) }
  let(:gem) { Factory[:gem] }
  let(:issues_ids) { [100, 101, 103] }
  let(:fake_gh_list) do
    [
      {id: 100, title: "Issue1", comments: 5, html_url: "repo/issues/1", state: "open"},
      {id: 101, title: "Issue2", comments: 53, html_url: "repo/issues/2", state: "closed"},
      {id: 102, title: "Issue3", comments: 52, html_url: "repo/issues/3", state: "open"},
      {id: 103, title: "Issue4", comments: 65, html_url: "repo/issues/4", state: "open"}
    ]
  end

  before do
    allow(fake_issues_list_fetcher).to receive(:call).with(gem.repo, all: true).and_return(Dry::Monads::Success(fake_gh_list))
  end

  subject { described_class.new(issues_list_fetcher: fake_issues_list_fetcher).call(gem: gems_repo.by_id(gem.id, with: [:issues]), issues_ids: issues_ids) }

  it "returns success" do
    expect(subject.success?).to be_truthy
  end

  it "removes closed issues" do
    subject
    expect(issues_relation.by_pk(existing_issue2.id).one).to be_nil
  end

  it "removes issues not on the list" do
    subject
    expect(issues_relation.by_pk(existing_issue3.id).one).to be_nil
  end

  it "updates open issues on the list" do
    subject
    expect(issues_relation.by_pk(existing_issue1.id).one).to match(hash_including({
      title: "Issue1",
      comments: 5,
      url: "repo/issues/1",
      gem_id: gem.id,
      github_id: 100
    }))
  end

  it "creates open issues on the list when not present in DB" do
    subject
    expect(issues_relation.last).to match(hash_including({
      title: "Issue4",
      comments: 65,
      url: "repo/issues/4",
      gem_id: gem.id,
      github_id: 103
    }))
  end
end
