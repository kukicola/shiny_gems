# frozen_string_literal: true

RSpec.describe Processing::Repositories::ReposRepository, type: :database do
  subject(:repository) { described_class.new }

  describe "#by_id" do
    let!(:repo) { Factory[:repo, issues: []] }

    context "repo exists" do
      it "returns gem" do
        expect(repository.by_id(repo.id)).to match_entity(repo)
      end
    end

    context "repo doesnt exist" do
      it "returns nil" do
        expect(repository.by_id(repo.id + 3)).to be_nil
      end
    end

    context "when 'with' present" do
      let!(:issue) { Factory[:issue, repo_id: repo.id] }

      it "returns repo with associations" do
        result = repository.by_id(repo.id, with: [:issues])
        expect(result.name).to eq(repo.name)
        expect(result.issues).to match([match_entity(issue)])
      end
    end
  end

  describe "#pluck_ids" do
    let!(:repo1) { Factory[:repo, id: 1] }
    let!(:repo2) { Factory[:repo, id: 2] }
    let!(:repo3) { Factory[:repo, id: 25] }

    it "returns ids as array" do
      expect(subject.pluck_ids_for_hour(1)).to eq([repo1.id, repo3.id])
    end
  end

  describe "#find_or_create" do
    context "already exists" do
      let!(:repo) { Factory[:repo] }

      it "returns repo" do
        expect(subject.find_or_create({name: repo.name})).to match(match_entity(repo))
      end

      it "doesn't create new repo" do
        expect { subject.find_or_create({name: repo.name}) }.not_to change { Hanami.app["persistence.rom"].relations[:repos].count }
      end
    end

    context "doesnt exist" do
      it "returns repo" do
        expect(subject.find_or_create({name: "name"})).to have_attributes(name: "name", id: kind_of(Integer))
      end

      it "creates new repo" do
        expect { subject.find_or_create({name: "name"}) }.to change { Hanami.app["persistence.rom"].relations[:repos].count }.by(1)
      end
    end
  end
end
