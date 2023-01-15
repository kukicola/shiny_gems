# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Show do
  let(:fake_gems_repository) do
    fake_repository(:web, :gems) do |repo|
      allow(repo).to receive(:by_id).with(gem.id, with: {repo: :issues}).and_return(gem)
      allow(repo).to receive(:by_id).with(-1, with: {repo: :issues}).and_return(nil)
    end
  end
  let(:repo) { Factory.structs[:repo] }
  let(:gem) { Factory.structs[:gem, repo: repo] }

  before do
    # bug in factory?
    allow(gem).to receive(:repo).and_return(repo)
  end

  context "gem not found" do
    subject { described_class.new(gems_repository: fake_gems_repository).call({id: -1}) }

    it "returns not found" do
      expect(subject.status).to eq(404)
    end
  end

  context "gem exists" do
    subject { described_class.new(gems_repository: fake_gems_repository).call({id: gem.id}) }

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes proper data" do
      expect(subject[:current_gem]).to eq(gem)
    end

    it "render view" do
      expect(subject.body[0]).to include(gem.name)
      expect(subject.body[0]).to include("Pending issues")
    end
  end
end
