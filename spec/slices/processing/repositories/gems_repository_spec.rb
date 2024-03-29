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
      it "returns gem with associations" do
        result = repo.by_id(gem.id, with: [:repo])
        expect(result.name).to eq(gem.name)
        expect(result.repo).to eq(gem.repo)
      end
    end
  end

  describe "#pluck_ids_for_hour" do
    let!(:gem1) { Factory[:gem, id: 1] }
    let!(:gem2) { Factory[:gem, id: 2] }
    let!(:gem3) { Factory[:gem, id: 25] }

    it "returns ids as array" do
      expect(subject.pluck_ids_for_hour(1)).to eq([gem1.id, gem3.id])
    end
  end

  describe "#pluck_name_by_list" do
    let!(:gem1) { Factory[:gem] }
    let!(:gem2) { Factory[:gem] }

    it "returns names of existing gems" do
      expect(subject.pluck_name_by_list(["some_name", gem2.name])).to eq([gem2.name])
    end
  end

  describe "#replace_repo" do
    let!(:gem1) { Factory[:gem] }
    let!(:gem2) { Factory[:gem] }
    let!(:new_repo) { Factory[:repo] }

    it "replaces repos for proper gems" do
      subject.replace_repo(gem1.repo_id, new_repo.id)

      expect(repo.by_id(gem1.id).repo_id).to eq(new_repo.id)
      expect(repo.by_id(gem2.id).repo_id).not_to eq(new_repo.id)
    end
  end
end
