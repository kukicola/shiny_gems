# frozen_string_literal: true

RSpec.describe ShinyGems::Entities::User do
  let(:user) { Factory.structs[:user] }

  describe "#github_token" do
    subject { user.github_token }

    it "returns decrypted token" do
      expect(subject).to eq("abc")
    end
  end
end
