# frozen_string_literal: true

RSpec.describe ShinyGems::Repositories::Users, type: :database do
  subject(:repo) { described_class.new }

  describe "#by_id" do
    let!(:user) { Factory[:user] }

    context "user exists" do
      it "returns user" do
        expect(repo.by_id(user.id)).to eq(user)
      end
    end

    context "user doesnt exist" do
      it "returns nil" do
        expect(repo.by_id(user.id + 3)).to be_nil
      end
    end
  end

  describe "#auth" do
    let(:expected_attributes) do
      {
        username: "test",
        avatar: "http://localhost/avatar.png",
        github_id: "235352"
      }
    end

    context "user exists" do
      let!(:user) { Factory[:user, github_id: "235352"] }

      it "returns updated user" do
        user = repo.auth(OmniAuth.config.mock_auth[:github])
        expect(user).to be_kind_of(ShinyGems::Entities::User)
        expect(user.attributes).to include(expected_attributes)
      end

      it "doesnt create new user" do
        expect { repo.auth(OmniAuth.config.mock_auth[:github]) }.not_to change { repo.users.to_a.size }
      end
    end

    context "user doesnt exist" do
      it "returns user" do
        user = repo.auth(OmniAuth.config.mock_auth[:github])
        expect(user).to be_kind_of(ShinyGems::Entities::User)
        expect(user.attributes).to include(expected_attributes)
        expect(user.github_token).to eq("abc")
      end

      it "saves user to DB" do
        expect { repo.auth(OmniAuth.config.mock_auth[:github]) }.to change { repo.users.to_a.size }.by(1)
      end
    end
  end
end
