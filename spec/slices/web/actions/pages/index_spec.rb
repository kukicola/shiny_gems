# frozen_string_literal: true

RSpec.describe Web::Actions::Pages::Index do
  let(:fake_gems_repository) do
    fake_repository(:web, :gems) do |repo|
      allow(repo).to receive(:random).with(3).and_return(result)
    end
  end
  let!(:gem) { OpenStruct.new(**Factory.structs[:gem].attributes, issues_count: 10) }
  let(:result) { [gem] }

  subject { described_class.new(gems_repository: fake_gems_repository).call({}) }

  it "calls repo with proper attributes" do
    expect(fake_gems_repository).to receive(:random)
      .with(3)
      .and_return(result)
    subject
  end

  it "is successful" do
    expect(subject).to be_successful
  end

  it "exposes proper data" do
    expect(subject[:random_gems]).to eq([gem])
  end

  it "render view" do
    expect(subject.body[0]).to include("Help maintain your favourite gems")
    expect(subject.body[0]).to include(gem.name)
  end
end
