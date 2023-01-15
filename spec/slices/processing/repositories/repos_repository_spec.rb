# frozen_string_literal: true

RSpec.describe Processing::Repositories::ReposRepository, type: :database do
  subject(:repository) { described_class.new }

  describe "#by_id" do
    let!(:repo) { Factory[:repo, issues: []] }

    context "repo exists" do
      it "returns gem" do
        expect(repository.by_id(repo.id)).to match_entity(repo)
      end
    end

    context "repo doesnt exist" do
      it "returns nil" do
        expect(repository.by_id(repo.id + 3)).to be_nil
      end
    end

    context "when 'with' present" do
      let!(:issue) { Factory[:issue, repo_id: repo.id] }

      it "returns repo with associations" do
        result = repository.by_id(repo.id, with: [:issues])
        expect(result.name).to eq(repo.name)
        expect(result.issues).to match([match_entity(issue)])
      end
    end
  end

  describe "#pluck_ids" do
    let!(:repo1) { Factory[:repo] }
    let!(:repo2) { Factory[:repo] }

    it "returns ids as array" do
      expect(subject.pluck_ids).to eq([repo1.id, repo2.id])
    end
  end
end
