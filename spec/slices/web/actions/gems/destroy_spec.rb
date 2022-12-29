# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Destroy do
  include_context "authorized user"

  let(:fake_gems_repository) do
    fake_repository(:gems) do |repo|
      allow(repo).to receive(:by_id).with(gem.id, with: [:issues]).and_return(gem)
      allow(repo).to receive(:by_id).with(-1, with: [:issues]).and_return(nil)
      allow(repo).to receive(:delete).with(gem.id)
    end
  end
  let(:gem) { Factory.structs[:gem, :with_issues, user: user.attributes] }

  context "gem belongs to someone else" do
    let(:gem) { Factory.structs[:gem, :with_issues, user: user.attributes.merge({id: -1})] }

    subject { described_class.new(gems_repository: fake_gems_repository).call(env.merge({id: gem.id})) }

    it "returns forbidden" do
      expect(subject.status).to eq(403)
    end
  end

  context "gem not found" do
    subject { described_class.new(gems_repository: fake_gems_repository).call(env.merge({id: -1})) }

    it "returns not found" do
      expect(subject.status).to eq(404)
    end
  end

  context "gem exists" do
    subject { described_class.new(gems_repository: fake_gems_repository).call(env.merge({id: gem.id})) }

    it "redirects to gem" do
      expect(subject.headers["Location"]).to eq("/gems/mine")
    end

    it "sets flash" do
      expect(subject.flash.next).to eq({success: "Gem removed"})
    end

    it "calls delete on repository" do
      expect(fake_gems_repository).to receive(:delete).with(gem.id)
      subject
    end
  end
end
