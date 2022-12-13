# frozen_string_literal: true

RSpec.describe ShinyGems::Services::Gems::Create do
  let(:fake_gemspec_parse_name) { instance_double(ShinyGems::Services::Gems::GemspecParseName) }
  let(:fake_rubygems_info) { instance_double(ShinyGems::Services::Gems::RubygemsInfo) }
  let(:fake_gemspec) { instance_double(ShinyGems::Services::Github::Gemspec) }
  let(:fake_repos_list) { instance_double(ShinyGems::Services::Github::ReposList) }
  let(:fake_gem_repo) { instance_double(ShinyGems::Repositories::GemsRepository) }
  let(:user) { Factory.structs[:user] }
  let(:gem) { Factory.structs[:gem] }
  let(:gemspec_dbl) { double }
  let(:repo_list) do
    [
      {full_name: "test/some_gem", stargazers_count: 50},
      {full_name: "test/different", stargazers_count: 100}
    ]
  end
  let(:gem_info) do
    {
      "name" => "some_gem",
      "info" => "some description",
      "downloads" => 50000,
      "homepage_uri" => "https://github.com/test/some_gem"
    }
  end
  let(:expected_attributes) do
    {
      name: "some_gem",
      repo: "test/some_gem",
      description: "some description",
      stars: 50,
      downloads: 50000,
      user_id: user.id
    }
  end

  subject do
    described_class.new(
      gemspec_parse_name: fake_gemspec_parse_name,
      rubygems_info: fake_rubygems_info,
      gemspec: fake_gemspec,
      repos_list: fake_repos_list,
      gem_repository: fake_gem_repo
    ).call(user: user, repo: "test/some_gem")
  end

  context "repo doesnt belong to user" do
    before do
      allow(fake_repos_list).to receive(:call).with(user).and_return(Dry::Monads::Success([]))
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:repo_ownership_check_failed)
    end
  end

  context "repo already exists" do
    before do
      allow(fake_repos_list).to receive(:call).with(user).and_return(Dry::Monads::Success(repo_list))
      allow(fake_gemspec).to receive(:call).with("test/some_gem").and_return(Dry::Monads::Success(gemspec_dbl))
      allow(fake_gemspec_parse_name).to receive(:call).with(gemspec_dbl).and_return(Dry::Monads::Success("some_gem"))
      allow(fake_rubygems_info).to receive(:call).with("some_gem").and_return(Dry::Monads::Success(gem_info))
      allow(fake_gem_repo).to receive(:create).with(expected_attributes).and_raise(ROM::SQL::UniqueConstraintError, Sequel::ConstraintViolation.new)
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gem_already_exists)
    end
  end

  context "source code url doesn't match" do
    let(:invalid_gem_info) do
      {
        "name" => "some_gem",
        "info" => "some description",
        "downloads" => 50000,
        "homepage_uri" => "https://github.com/something_else/some_gem"
      }
    end

    before do
      allow(fake_repos_list).to receive(:call).with(user).and_return(Dry::Monads::Success(repo_list))
      allow(fake_gemspec).to receive(:call).with("test/some_gem").and_return(Dry::Monads::Success(gemspec_dbl))
      allow(fake_gemspec_parse_name).to receive(:call).with(gemspec_dbl).and_return(Dry::Monads::Success("some_gem"))
      allow(fake_rubygems_info).to receive(:call).with("some_gem").and_return(Dry::Monads::Success(invalid_gem_info))
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:source_code_url_doesnt_match)
    end
  end

  context "one of services returns failure" do
    before do
      allow(fake_repos_list).to receive(:call).with(user).and_return(Dry::Monads::Success(repo_list))
      allow(fake_gemspec).to receive(:call).with("test/some_gem").and_return(Dry::Monads::Failure(:gemspec_fetch_failed))
    end

    it "returns failure" do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to eq(:gemspec_fetch_failed)
    end
  end

  context "everything goes ok" do
    before do
      allow(fake_repos_list).to receive(:call).with(user).and_return(Dry::Monads::Success(repo_list))
      allow(fake_gemspec).to receive(:call).with("test/some_gem").and_return(Dry::Monads::Success(gemspec_dbl))
      allow(fake_gemspec_parse_name).to receive(:call).with(gemspec_dbl).and_return(Dry::Monads::Success("some_gem"))
      allow(fake_rubygems_info).to receive(:call).with("some_gem").and_return(Dry::Monads::Success(gem_info))
      allow(fake_gem_repo).to receive(:create).with(expected_attributes).and_return(gem)
    end

    it "returns saved gem" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to eq(gem)
    end
  end
end
