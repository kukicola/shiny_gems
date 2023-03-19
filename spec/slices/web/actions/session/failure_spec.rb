# frozen_string_literal: true

RSpec.describe Web::Actions::Session::Failure do
  subject { described_class.new.call({}) }

  it "redirects to homepage" do
    expect(subject.headers["Location"]).to eq("/")
  end

  it "sets flash message" do
    expect(subject.flash.next).to eq({warning: "Error: couldn't sign in"})
  end
end
