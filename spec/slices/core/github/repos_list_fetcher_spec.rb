# frozen_string_literal: true

Core::Slice.prepare(:octokit)

RSpec.describe Core::Services::Github::ReposListFetcher do
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

  context "everything is ok" do
    before do
      allow(fake_octokit).to receive(:new).with(access_token: "abc").and_return(fake_octokit_instance)
      allow(fake_octokit_instance).to receive(:repos).with({}, query: {sort: "asc"}).and_return(fake_response)
    end

    it "fetches data from octokit and returns list of repos" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(fake_response)
    end
  end

  context "api error" do
    before do
      allow(fake_octokit).to receive(:new).with(access_token: "abc").and_return(fake_octokit_instance)
      allow(fake_octokit_instance).to receive(:repos).with({}, query: {sort: "asc"}).and_raise(Octokit::NotFound)
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:repos_list_failed)
    end
  end
end
