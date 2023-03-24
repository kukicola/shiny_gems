# frozen_string_literal: true

RSpec.describe Web::Repositories::FavoritesRepository, type: :database do
  subject(:repository) { described_class.new }

  describe "#favorite?" do
    let(:gem) { Factory[:gem] }
    let(:user) { Factory[:user] }

    context "when user has favorite" do
      before { Factory[:favorite, user_id: user.id, gem_id: gem.id] }

      it "returns true" do
        expect(repository.favorite?(user_id: user.id, gem_id: gem.id)).to be_truthy
      end
    end

    context "without favorite" do
      it "returns false" do
        expect(repository.favorite?(user_id: user.id, gem_id: gem.id)).to be_falsey
      end
    end
  end

  describe "#total_favorites" do
    let(:gem1) { Factory[:gem] }
    let(:gem2) { Factory[:gem] }
    let(:user1) { Factory[:user] }
    let(:user2) { Factory[:user] }
    let(:user3) { Factory[:user] }

    before do
      Factory[:favorite, user_id: user1.id, gem_id: gem1.id]
      Factory[:favorite, user_id: user2.id, gem_id: gem1.id]
      Factory[:favorite, user_id: user3.id, gem_id: gem2.id]
    end

    it "returns proper count of favorites" do
      expect(repository.total_favorites(gem1.id)).to eq(2)
      expect(repository.total_favorites(gem2.id)).to eq(1)
    end
  end

  describe "#unlink" do
    let(:gem) { Factory[:gem] }
    let(:user) { Factory[:user] }

    before { Factory[:favorite, user_id: user.id, gem_id: gem.id] }

    it "removes association" do
      repository.unlink(user_id: user.id, gem_id: gem.id)
      expect(repository.favorite?(user_id: user.id, gem_id: gem.id)).to be_falsey
    end
  end
end
