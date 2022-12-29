# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Issues::Edit do
  include_context "authorized user"

  let(:fake_issues_list_fetcher) { instance_double(Core::Services::Github::IssuesListFetcher) }
  let(:fake_gem_repo) do
    fake_repository(:gems) do |repo|
      allow(repo).to receive(:by_id).with(gem.id, with: [:issues]).and_return(gem)
    end
  end
  let(:gem) { Factory.structs[:gem, :with_issues, repo: "test/repo", user: user.attributes] }

  subject { described_class.new(issues_list_fetcher: fake_issues_list_fetcher, gems_repository: fake_gem_repo).call(env.merge(id: gem.id)) }

  context "issues list fetched successfully" do
    before do
      allow(fake_issues_list_fetcher).to receive(:call).with("test/repo")
        .and_return(Dry::Monads::Success([]))
    end

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes list" do
      expect(subject[:issues]).to eq([])
    end

    it "render view" do
      expect(subject.body[0]).to include("Select issues")
    end
  end

  context "issues list fetched failed" do
    before do
      allow(fake_issues_list_fetcher).to receive(:call).with("test/repo")
        .and_return(Dry::Monads::Failure(:issues_list_failed))
    end

    it "redirects to gem list" do
      expect(subject.headers["Location"]).to eq("/gems/#{gem.id}")
    end

    it "sets flash" do
      expect(subject.flash.next).to eq({warning: "Couldn't fetch issues from GitHub"})
    end
  end

  context "gem belongs to someone else" do
    let(:gem) { Factory.structs[:gem, repo: "test/repo", user: user.attributes.merge({id: -1})] }

    it "returns forbidden" do
      expect(subject.status).to eq(403)
    end
  end

  context "user not logged in" do
    let(:env) { {} }

    it "redirects to homepage" do
      expect(subject.headers["Location"]).to eq("/")
    end

    it "sets flash" do
      expect(subject.flash.next).to eq({warning: "You need to sign in first"})
    end
  end
end
