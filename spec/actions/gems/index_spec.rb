# frozen_string_literal: true

RSpec.describe ShinyGems::Actions::Gems::Index, type: :database do
  let(:gems_repository) { ShinyGems::Repositories::GemsRepository.new }
  let!(:gem) { Factory[:gem] }

  subject { described_class.new(gems_repository: gems_repository).call(env) }

  context "invalid params" do
    let(:env) { {sort_by: "hehe"} }

    it "returns bad request" do
      expect(subject.status).to eq(400)
    end
  end

  context "valid params" do
    let(:env) { {sort_by: "downloads", page: 1} }

    it "calls repo with proper attributes" do
      expect(gems_repository).to receive(:index)
        .with(page: 1, order: "downloads", order_dir: "desc")
        .and_call_original
      subject
    end

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes proper data" do
      expect(subject[:sort_by]).to eq("downloads")
      expect(subject[:gems].to_a).to match([match_entity(gem)])
    end

    it "render view" do
      expect(subject.body[0]).to include("Browse gems")
      expect(subject.body[0]).to include(gem.name)
    end
  end
end
