# frozen_string_literal: true

Hanami.app["octokit"]

RSpec.describe ShinyGems::Services::Github::IssuesList do
  let(:fake_octokit) { instance_double(Octokit::Client) }
  let(:fake_response) do
    [
      {id: 231},
      {id: 233, pull_request: {id: 123}}
    ]
  end

  subject { described_class.new(octokit: fake_octokit).call("some/repo") }

  context "everything is ok" do
    before do
      allow(fake_octokit).to receive(:list_issues).with("some/repo", sort: "created", state: "all")
        .and_return(fake_response)
    end

    it "fetches data from octokit and returns issues without PRs" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq([{id: 231}])
    end
  end

  context "api error" do
    before do
      allow(fake_octokit).to receive(:list_issues).with("some/repo", sort: "created", state: "all")
        .and_raise(Octokit::NotFound)
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:issues_list_failed)
    end
  end
end
