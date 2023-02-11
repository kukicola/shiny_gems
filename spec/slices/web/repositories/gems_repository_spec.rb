# frozen_string_literal: true

RSpec.describe Web::Repositories::GemsRepository, type: :database do
  subject(:repository) { described_class.new }

  describe "#by_id" do
    let!(:repo) { Factory[:repo] }
    let!(:gem) { Factory[:gem, repo_id: repo.id] }

    context "gem exists" do
      it "returns gem" do
        expect(repository.by_id(gem.id)).to match_entity(gem)
      end
    end

    context "gem doesnt exist" do
      it "returns nil" do
        expect(repository.by_id(gem.id + 3)).to be_nil
      end
    end

    context "when 'with' present" do
      it "returns gem with associations" do
        result = repository.by_id(gem.id, with: [:repo])
        expect(result.name).to eq(gem.name)
        expect(result.repo).to match(match_entity(repo))
      end
    end
  end

  describe "#index" do
    let!(:gem1) { Factory[:gem, repo: Factory[:repo], downloads: 3000] }
    let!(:gem2) { Factory[:gem, repo: Factory[:repo], downloads: 5000] }
    let!(:gem3) { Factory[:gem, repo: Factory[:repo], downloads: 4000] }
    let!(:gem4) { Factory[:gem, repo: Factory[:repo, issues: []]] }
    let!(:gem5) { Factory[:gem, repo: Factory[:repo, pushed_at: DateTime.now - 400]] }

    it "returns paginated data except for gems without issues or outdated" do
      expect(subject.index(per_page: 2, page: 1).to_a.map(&:id))
        .to eq([gem2.id, gem3.id])
      expect(subject.index(per_page: 2, page: 2).to_a.map(&:id))
        .to eq([gem1.id])
    end

    it "returns pager" do
      expect(subject.index(per_page: 2, page: 1).pager).not_to be_nil
    end
  end

  describe "#by_list" do
    let!(:gem1) { Factory[:gem, repo: Factory[:repo]] }
    let!(:gem2) { Factory[:gem, repo: Factory[:repo]] }
    let!(:gem3) { Factory[:gem, repo: Factory[:repo, stars: 20, issues: []]] }
    let!(:gem4) { Factory[:gem, repo: Factory[:repo, pushed_at: DateTime.now - 400]] }

    it "returns gems from given list except for gems without issues or outdated" do
      expect(subject.by_list([gem1.name, gem2.name, gem3.name, gem4.name]).to_a.map(&:id))
        .to eq([gem1.id, gem2.id])
    end
  end

  describe "#random" do
    let!(:gem1) { Factory[:gem, repo: Factory[:repo]] }
    let!(:gem2) { Factory[:gem, repo: Factory[:repo]] }

    it "returns random N gems" do
      expect(subject.random(1).to_a.map(&:id)).to eq([gem1.id]).or(eq([gem2.id]))
    end
  end
end
