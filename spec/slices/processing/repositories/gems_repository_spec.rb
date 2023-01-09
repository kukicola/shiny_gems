# frozen_string_literal: true

RSpec.describe Processing::Repositories::GemsRepository, type: :database do
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

  describe "#pluck_ids" do
    let!(:gem1) { Factory[:gem] }
    let!(:gem2) { Factory[:gem] }

    it "returns ids as array" do
      expect(subject.pluck_ids).to eq([gem1.id, gem2.id])
    end
  end
end
