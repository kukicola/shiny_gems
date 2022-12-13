# frozen_string_literal: true

RSpec.describe ShinyGems::AdminMiddleware, type: :database do
  let(:fake_app) { double({call: "ok"}) }

  subject { described_class.new(fake_app).call(env) }

  context "user not present in session" do
    let(:env) { {"rack.session" => {}} }

    it "returns forbidden" do
      expect(subject).to eq([403, {"Content-Type" => "text/plain"}, ["Forbidden"]])
    end
  end

  context "user is not an admin" do
    let(:env) { {"rack.session" => {user_id: user.id}} }
    let(:user) { Factory[:user] }

    it "returns forbidden" do
      expect(subject).to eq([403, {"Content-Type" => "text/plain"}, ["Forbidden"]])
    end
  end

  context "user is an admin" do
    let(:env) { {"rack.session" => {user_id: user.id}} }
    let(:user) { Factory[:user, admin: true] }

    it "calls app" do
      expect(subject).to eq("ok")
    end
  end
end
