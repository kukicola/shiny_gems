# frozen_string_literal: true

RSpec.describe ShinyGems::Repositories::GemsRepository, type: :database do
  subject(:repo) { described_class.new }

  describe "#by_id" do
    let!(:gem) { Factory[:gem] }

    context "gem exists" do
      it "returns gem" do
        expect(repo.by_id(gem.id).attributes).to eq(gem.attributes.except(:user))
      end
    end

    context "gem doesnt exist" do
      it "returns nil" do
        expect(repo.by_id(gem.id + 3)).to be_nil
      end
    end
  end

  describe "#pluck_ids" do
    let!(:gem1) { Factory[:gem] }
    let!(:gem2) { Factory[:gem] }

    it "returns ids as array" do
      expect(subject.pluck_ids).to eq([gem1.id, gem2.id])
    end
  end

  describe "#index" do
    let!(:gem1) { Factory[:gem, stars: 10] }
    let!(:gem2) { Factory[:gem, stars: 30] }
    let!(:gem3) { Factory[:gem, stars: 20] }

    it "returns paginated data" do
      expect(subject.index(per_page: 2, page: 1, order: "stars", order_dir: "desc").to_a.map(&:attributes))
        .to eq([gem2.attributes.except(:user), gem3.attributes.except(:user)])
      expect(subject.index(per_page: 2, page: 2, order: "stars", order_dir: "desc").to_a.map(&:attributes))
        .to eq([gem1.attributes.except(:user)])
    end
  end
end
