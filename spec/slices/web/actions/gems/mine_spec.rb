# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Mine do
  include_context "authorized user"

  let(:gem) { Factory.structs[:gem] }
  let(:fake_gems_repository) do
    fake_repository(:gems) do |repo|
      allow(repo).to receive(:belonging_to_user).with(user.id).and_return([gem])
    end
  end

  subject { described_class.new(gems_repository: fake_gems_repository).call(env) }

  context "user logged in" do
    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes list" do
      expect(subject[:gems]).to eq([gem])
    end

    it "render view" do
      expect(subject.body[0]).to include("My gems")
      expect(subject.body[0]).to include(gem.name)
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
