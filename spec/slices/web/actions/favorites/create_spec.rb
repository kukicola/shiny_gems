# frozen_string_literal: true

RSpec.describe Web::Actions::Favorites::Create do
  include_context "authorized user"

  subject do
    described_class.new(gems_repository: fake_gem_repository, favorites_repository: fake_favorites_repository)
      .call(env.merge({name: "test"}))
  end

  let(:gem) { Factory.structs[:gem, name: "test"] }
  let(:fake_gem_repository) do
    fake_repository(:web, :gem) do |repository|
      allow(repository).to receive(:by_name).with(gem.name).and_return(gem)
    end
  end
  let(:fake_favorites_repository) do
    fake_repository(:web, :favorites) do |repository|
      allow(repository).to receive(:create).with(gem_id: gem.id, user_id: user.id)
    end
  end

  it "redirects to gem" do
    expect(subject.headers["Location"]).to eq("/gems/test")
  end

  it "saves favorite" do
    expect(fake_favorites_repository).to receive(:create).with(gem_id: gem.id, user_id: user.id)
    subject
  end

  it "sets flash message" do
    expect(subject.flash.next).to eq({success: "Gem added to favorites"})
  end
end
