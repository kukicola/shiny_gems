# frozen_string_literal: true

RSpec.describe ShinyGems::Actions::Gems::New do
  let(:fake_repos_list) { instance_double(ShinyGems::Services::Github::ReposList) }

  with_user

  subject { described_class.new(repos_list: fake_repos_list).call(env) }

  context "repo list fetched successfully" do
    before do
      allow(fake_repos_list).to receive(:call).with(user)
        .and_return(Dry::Monads::Success([]))
    end

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes list" do
      expect(subject[:repos]).to eq([])
    end

    it "render view" do
      expect(subject.body[0]).to include("Add new gem")
    end
  end

  context "repo list fetched failed" do
    before do
      allow(fake_repos_list).to receive(:call).with(user)
        .and_return(Dry::Monads::Failure(:repos_list_failed))
    end

    it "redirects to gem list" do
      expect(subject.headers["Location"]).to eq("/gems/mine")
    end

    it "sets flash" do
      expect(subject.flash.next).to eq({warning: "Couldn't fetch your repositories from GitHub"})
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
