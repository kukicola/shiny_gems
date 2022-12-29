# frozen_string_literal: true

RSpec.describe Auth::Actions::Destroy do
  subject { described_class.new.call(env) }

  let(:env) { {"rack.session" => {"user_id" => 3}} }

  it "redirects to homepage" do
    expect(subject.headers["Location"]).to eq("/")
  end

  it "clears user id from session" do
    expect(subject.session[:user_id]).to be_nil
  end

  it "sets flash message" do
    expect(subject.flash.next).to eq({success: "Successfully signed out"})
  end
end
