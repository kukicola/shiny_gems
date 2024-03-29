# frozen_string_literal: true

Processing::Slice.prepare(:octokit)

RSpec.describe Processing::Services::Github::RepoFetcher do
  let(:fake_octokit) { instance_double(Octokit::Client) }
  let(:fake_response) do
    {full_name: "some/repo", name: "repo"}
  end

  subject { described_class.new(octokit: fake_octokit).call("some/repo") }

  context "everything is ok" do
    before do
      allow(fake_octokit).to receive(:repo).with("some/repo").and_return(fake_response)
    end

    it "fetches data from octokit and returns repo data" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(fake_response)
    end
  end

  context "api error" do
    before do
      allow(fake_octokit).to receive(:repo).with("some/repo").and_raise(Octokit::NotFound)
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to be_instance_of(Octokit::NotFound)
    end
  end
end
