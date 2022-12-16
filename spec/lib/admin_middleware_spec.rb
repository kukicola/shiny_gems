# frozen_string_literal: true

RSpec.describe ShinyGems::AdminMiddleware do
  let(:fake_app) { double({call: "ok"}) }
  let(:fake_users_repository) do
    fake_repository(:users) do |repo|
      allow(repo).to receive(:by_id).with(user.id).and_return(user)
    end
  end

  subject { described_class.new(fake_app, users_repository: fake_users_repository).call(env) }

  context "user not present in session" do
    let(:env) { {"rack.session" => {}} }
    let(:user) { Factory.structs[:user] }

    it "returns forbidden" do
      expect(subject).to eq([403, {"Content-Type" => "text/plain"}, ["Forbidden"]])
    end
  end

  context "user is not an admin" do
    let(:env) { {"rack.session" => {user_id: user.id}} }
    let(:user) { Factory.structs[:user] }

    it "returns forbidden" do
      expect(subject).to eq([403, {"Content-Type" => "text/plain"}, ["Forbidden"]])
    end
  end

  context "user is an admin" do
    let(:env) { {"rack.session" => {user_id: user.id}} }
    let(:user) { Factory.structs[:user, admin: true] }

    it "calls app" do
      expect(subject).to eq("ok")
    end
  end
end
