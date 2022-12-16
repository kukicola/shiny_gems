# frozen_string_literal: true

RSpec.describe ShinyGems::Actions::Gems::Index do
  let(:fake_gems_repository) do
    fake_repository(:gems) do |repo|
      allow(repo).to receive(:index).with(any_args).and_return(result)
    end
  end
  let!(:gem) { Factory.structs[:gem, :with_issues] }
  let(:result) { double(to_a: [gem], pager: pager_dbl) }
  let(:pager_dbl) { instance_double(ROM::SQL::Plugin::Pagination::Pager, total_pages: 3, current_page: 1) }

  subject { described_class.new(gems_repository: fake_gems_repository).call(env) }

  context "invalid params" do
    let(:env) { {sort_by: "hehe"} }

    it "returns bad request" do
      expect(subject.status).to eq(400)
    end
  end

  context "valid params" do
    let(:env) { {sort_by: "downloads", page: 1} }

    it "calls repo with proper attributes" do
      expect(fake_gems_repository).to receive(:index)
        .with(page: 1, order: "downloads", order_dir: "desc")
        .and_return(result)
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
