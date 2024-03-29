# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Index do
  let(:fake_gems_repository) do
    fake_repository(:web, :gems) do |repo|
      allow(repo).to receive(:index).with(any_args).and_return(result)
    end
  end
  let!(:gem) { OpenStruct.new(**Factory.structs[:gem].attributes, issues_count: 10) }
  let(:result) { double(to_a: [gem], pager: pager_dbl) }
  let(:pager_dbl) { instance_double(ROM::SQL::Plugin::Pagination::Pager, total_pages: 3, current_page: 1) }

  subject { described_class.new(gems_repository: fake_gems_repository).call(env) }

  context "invalid params" do
    let(:env) { {page: "hehe"} }

    it "returns bad request" do
      puts gem.attributes
      expect(subject.status).to eq(400)
    end
  end

  context "valid params" do
    let(:env) { {page: 1, sort_by: "name"} }

    it "calls repo with proper attributes" do
      expect(fake_gems_repository).to receive(:index)
        .with(page: 1, order: "name")
        .and_return(result)
      subject
    end

    it "is successful" do
      expect(subject).to be_successful
    end

    it "exposes proper data" do
      expect(subject[:gems].to_a).to eq([gem])
    end

    it "render view" do
      expect(subject.body[0]).to include("Browse gems")
      expect(subject.body[0]).to include(gem.name)
    end
  end
end
