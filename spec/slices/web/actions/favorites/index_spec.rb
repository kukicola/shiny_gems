# frozen_string_literal: true

RSpec.describe Web::Actions::Favorites::Index do
  include_context "authorized user"

  let(:fake_gems_repository) do
    fake_repository(:web, :gems) do |repo|
      allow(repo).to receive(:user_favorites).with(user.id).and_return([gem])
    end
  end
  let(:gem) { OpenStruct.new(**Factory.structs[:gem].attributes, issues_count: 10) }

  subject { described_class.new(gems_repository: fake_gems_repository).call(env) }

  it "calls repo with proper attributes" do
    expect(fake_gems_repository).to receive(:user_favorites)
      .with(user.id)
      .and_return([gem])
    subject
  end

  it "is successful" do
    expect(subject).to be_successful
  end

  it "exposes proper data" do
    expect(subject[:gems]).to eq([gem])
  end

  it "render view" do
    expect(subject.body[0]).to include("Favorites")
    expect(subject.body[0]).to include(gem.name)
  end
end
