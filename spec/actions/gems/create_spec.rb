# frozen_string_literal: true

RSpec.describe ShinyGems::Actions::Gems::Create do
  include_context "authorized user"

  let(:instance) { described_class.new(creator: fake_creator, new: fake_new_action.new) }
  let(:fake_new_action) do
    Class.new do
      def handle(_, response)
        response[:repos] = []
      end
    end
  end
  let(:fake_creator) { instance_double(ShinyGems::Services::Gems::Creator) }

  context "when params invalid" do
    subject { instance.call(env.merge({params: {}})) }

    it "returns bad request" do
      expect(subject.status).to eq(400)
    end
  end

  context "when gem create failed" do
    before do
      allow(fake_creator).to receive(:call).with(user: user, repo: "test/abc")
        .and_return(Dry::Monads::Failure(:gem_already_exists))
    end

    subject { instance.call(env.merge({repository: "test/abc"})) }

    it "is successful" do
      expect(subject).to be_successful
    end

    it "delagates request handle to new action" do
      expect(subject[:repos]).to eq([])
    end

    it "exposes proper data" do
      expect(subject[:error]).to eq("Gem already exists")
      expect(subject[:current_repo]).to eq("test/abc")
    end

    it "render view" do
      expect(subject.body[0]).to include("Add new gem")
    end
  end

  context "when gem create successful" do
    let(:gem) { Factory.structs[:gem, id: 5] }

    before do
      allow(fake_creator).to receive(:call).with(user: user, repo: "test/abc")
        .and_return(Dry::Monads::Success(gem))
    end

    subject { instance.call(env.merge({repository: "test/abc"})) }

    it "redirects to gem" do
      expect(subject.headers["Location"]).to eq("/gems/5/issues/edit")
    end
  end
end
