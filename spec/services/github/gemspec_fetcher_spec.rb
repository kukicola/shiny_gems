# frozen_string_literal: true

Hanami.app.prepare(:octokit)

RSpec.describe ShinyGems::Services::Github::GemspecFetcher do
  let(:fake_octokit) { instance_double(Octokit::Client) }

  subject { described_class.new(octokit: fake_octokit).call("some/repo") }

  context "when API error" do
    before { allow(fake_octokit).to receive(:contents).with("some/repo").and_raise(Octokit::NotFound) }

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gemspec_fetch_failed)
    end
  end

  context "when repo doesn't contain gemspec" do
    let(:files) do
      [
        {name: "some_file.txt"},
        {name: "another_file.txt"}
      ]
    end

    before { allow(fake_octokit).to receive(:contents).with("some/repo").and_return(files) }

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gemspec_not_found)
    end
  end

  context "when repo contains gemspec" do
    let(:files) do
      [
        {name: "gemname.gemspec"},
        {name: "another_file.txt"}
      ]
    end

    let(:gemspec) do
      {
        name: "gemname.gemspec",
        content: "dGVzdA==\n"
      }
    end

    before do
      allow(fake_octokit).to receive(:contents).with("some/repo").and_return(files)
      allow(fake_octokit).to receive(:contents).with("some/repo", path: "gemname.gemspec").and_return(gemspec)
    end

    it "returns content of gemspec" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq("test")
    end
  end
end
