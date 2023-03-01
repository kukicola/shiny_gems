# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::ShowOld do
  let(:fake_gems_repository) do
    fake_repository(:web, :gems) do |repo|
      allow(repo).to receive(:by_id).with(gem.id).and_return(gem)
    end
  end
  let(:gem) { Factory.structs[:gem, name: "test"] }

  subject { described_class.new(gems_repository: fake_gems_repository).call({id: gem.id}) }

  it "is redirects to new endpoint" do
    expect(subject.status).to eq(301)
    expect(subject.headers["Location"]).to eq("/gems/test")
  end
end
