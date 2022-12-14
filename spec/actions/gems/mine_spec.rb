# frozen_string_literal: true

RSpec.describe ShinyGems::Actions::Gems::Mine do
  let(:fake_gems_repository) { instance_double(ShinyGems::Repositories::GemsRepository) }

  with_user

  subject { described_class.new(gems_repository: fake_gems_repository).call(env) }

  context "user logged in" do
    let(:gem) { Factory.structs[:gem] }

    before do
      allow(fake_gems_repository).to receive(:belonging_to_user).with(user.id).and_return([gem])
    end

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes list" do
      expect(subject[:gems]).to match([match_entity(gem)])
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
