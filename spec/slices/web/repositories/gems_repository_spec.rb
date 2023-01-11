# frozen_string_literal: true

RSpec.describe Web::Repositories::GemsRepository, type: :database do
  subject(:repo) { described_class.new }

  describe "#by_id" do
    let!(:gem) { Factory[:gem] }

    context "gem exists" do
      it "returns gem" do
        expect(repo.by_id(gem.id)).to match_entity(gem)
      end
    end

    context "gem doesnt exist" do
      it "returns nil" do
        expect(repo.by_id(gem.id + 3)).to be_nil
      end
    end

    context "when 'with' present" do
      let!(:issue) { Factory[:issue, gem_id: gem.id] }

      it "returns gem with associations" do
        result = repo.by_id(gem.id, with: [:issues])
        expect(result.name).to eq(gem.name)
        expect(result.issues).to match([match_entity(issue)])
      end
    end
  end

  describe "#index" do
    let!(:gem1) { Factory[:gem, :with_issues, stars: 10] }
    let!(:gem2) { Factory[:gem, :with_issues, stars: 30] }
    let!(:gem3) { Factory[:gem, :with_issues, stars: 20] }
    let!(:gem4) { Factory[:gem, stars: 20] }
    let!(:gem5) { Factory[:gem, :with_issues, pushed_at: DateTime.now - 400] }

    it "returns paginated data except for gems without issues or outdated" do
      expect(subject.index(per_page: 2, page: 1, order: "stars", order_dir: "desc").to_a)
        .to match([match_entity(gem2), match_entity(gem3)])
      expect(subject.index(per_page: 2, page: 2, order: "stars", order_dir: "desc").to_a)
        .to match([match_entity(gem1)])
    end

    it "returns pager" do
      expect(subject.index(per_page: 2, page: 1, order: "stars", order_dir: "desc").pager).not_to be_nil
    end
  end

  describe "#by_list" do
    let!(:gem1) { Factory[:gem, :with_issues] }
    let!(:gem2) { Factory[:gem, :with_issues] }
    let!(:gem3) { Factory[:gem, stars: 20] }
    let!(:gem4) { Factory[:gem, :with_issues, pushed_at: DateTime.now - 400] }

    it "returns gems from given list except for gems without issues or outdated" do
      expect(subject.by_list([gem1.name, gem2.name, gem3.name, gem4.name]).to_a)
        .to match_array([match_entity(gem1), match_entity(gem2)])
    end
  end
end
