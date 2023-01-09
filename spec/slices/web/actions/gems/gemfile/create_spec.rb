# frozen_string_literal: true

RSpec.describe Web::Actions::Gems::Gemfile::Create do
  let(:fake_parser) { instance_double(Web::Services::GemfileParser) }
  let(:instance) { described_class.new(gemfile_parser: fake_parser, gems_repository: fake_gems_repository) }
  let(:fake_gems_repository) { fake_repository(:web, :gems) }
  let(:gem) { Factory.structs[:gem, name: "hanami"] }

  subject { instance.call({gemfile: {tempfile: File.open("#{SPEC_ROOT}/support/files/Gemfile.test")}}) }

  context "gemfile parse successful" do
    before do
      allow(fake_parser).to receive(:call).with("gem \"hanami\", \"~> 2.0\"\n")
        .and_return(Dry::Monads::Success(["hanami"]))
      allow(fake_gems_repository).to receive(:by_list).with(["hanami"]).and_return([gem])
    end

    it "exposes proper data" do
      expect(subject[:gems].to_a).to eq([gem])
    end

    it "render view" do
      expect(subject.body[0]).to include("Gems from your Gemfile")
      expect(subject.body[0]).to include(gem.name)
    end
  end

  context "gemfile parse successful but there are no gems in DB" do
    before do
      allow(fake_parser).to receive(:call).with("gem \"hanami\", \"~> 2.0\"\n")
        .and_return(Dry::Monads::Success(["hanami"]))
      allow(fake_gems_repository).to receive(:by_list).with(["hanami"]).and_return([])
    end

    it "exposes proper data" do
      expect(subject[:gems].to_a).to eq([])
    end

    it "render view" do
      expect(subject.body[0]).to include("Gems from your Gemfile")
      expect(subject.body[0]).to include("Couldn't find any gems from your gemfile in our database")
    end
  end

  context "gemfile parse failed" do
    before do
      allow(fake_parser).to receive(:call).with("gem \"hanami\", \"~> 2.0\"\n")
        .and_return(Dry::Monads::Failure(:no_gems_in_gemfile))
    end

    it "redirects to gem index" do
      expect(subject.headers["Location"]).to eq("/gems")
    end

    it "sets flash" do
      expect(subject.flash.next).to eq({warning: "No gems found in file, are you sure it's a correct Gemfile?"})
    end
  end
end
