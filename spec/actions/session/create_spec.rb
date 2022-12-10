# frozen_string_literal: true

RSpec.describe ShinyGems::Actions::Session::Create do
  subject { described_class.new(users_repository: fake_repo).call(env) }

  let(:auth_mock) { OmniAuth.config.mock_auth[:github] }
  let(:user) { Factory.structs[:user, id: 2] }
  let(:fake_repo) { instance_double(ShinyGems::Repositories::Users, {auth: user}) }
  let(:env) { {"omniauth.auth" => OmniAuth.config.mock_auth[:github]} }

  it "redirects to homepage" do
    expect(subject.headers["Location"]).to eq("/")
  end

  it "saves user id returned from repo to session" do
    expect(fake_repo).to receive(:auth).with(auth_mock).and_return(user)
    expect(subject.session[:user_id]).to eq(2)
  end

  it "sets flash message" do
    expect(subject.flash.next).to eq({success: "Successfully signed in"})
  end
end
