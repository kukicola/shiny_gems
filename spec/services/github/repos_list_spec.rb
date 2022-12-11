# frozen_string_literal: true

Hanami.app["octokit"]

RSpec.describe ShinyGems::Services::Github::ReposList do
  let(:user) { Factory.structs[:user] }
  let(:fake_octokit) { class_double(Octokit::Client) }
  let(:fake_octokit_instance) { instance_double(Octokit::Client) }
  let(:fake_response) do
    [
      {full_name: "some/repo", name: "repo"},
      {full_name: "another/repo", name: "another"}
    ]
  end

  subject { described_class.new(octokit: fake_octokit).call(user) }

  it "fetches data from octokit and returns list of repos" do
    expect(fake_octokit).to receive(:new).with(access_token: "abc").and_return(fake_octokit_instance)
    expect(fake_octokit_instance).to receive(:repos).with({}, query: {sort: "asc"}).and_return(fake_response)
    expect(subject).to eq(["some/repo", "another/repo"])
  end
end
