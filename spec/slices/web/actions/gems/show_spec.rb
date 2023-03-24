# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Show do
  include_context "authorized user"

  let(:fake_gems_repository) do
    fake_repository(:web, :gems) do |repo|
      allow(repo).to receive(:by_name).with(gem.name, with: {repo: [:issues, :gems]}).and_return(gem)
      allow(repo).to receive(:by_name).with("eo", with: {repo: [:issues, :gems]}).and_return(nil)
    end
  end
  let(:fake_favorites_repository) do
    fake_repository(:web, :favorites) do |repo|
      allow(repo).to receive(:favorite?).with(user_id: user.id, gem_id: gem.id).and_return(true)
      allow(repo).to receive(:total_favorites).with(gem.id).and_return(5)
    end
  end
  let(:repo) { Factory.structs[:repo] }
  let(:gem) { Factory.structs[:gem, repo: repo] }
  let(:instance) { described_class.new(gems_repository: fake_gems_repository, favorites_repository: fake_favorites_repository) }

  before do
    # bug in factory?
    allow(gem).to receive(:repo).and_return(repo)
  end

  context "gem not found" do
    subject { instance.call(env.merge({name: "eo"})) }

    it "returns not found" do
      expect(subject.status).to eq(404)
    end
  end

  context "gem exists" do
    subject { instance.call(env.merge({name: gem.name})) }

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes proper data" do
      expect(subject[:current_gem]).to eq(gem)
      expect(subject[:favorite]).to eq(true)
      expect(subject[:total_favorites]).to eq(5)
    end

    it "render view" do
      expect(subject.body[0]).to include(gem.name)
      expect(subject.body[0]).to include(repo.issues[0].title)
    end
  end
end
