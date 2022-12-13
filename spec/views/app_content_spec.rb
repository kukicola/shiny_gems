# frozen_string_literal: true

RSpec.describe ShinyGems::Views::AppContext do
  describe "#current_user" do
    subject { described_class.new(request: request, users_repository: fake_repo).current_user }

    let(:user) { Factory.structs[:user, id: 2] }
    let(:fake_repo) { instance_double(ShinyGems::Repositories::UsersRepository) }
    let(:request) { Hanami::Action::Request.new(env: env, params: {}, sessions_enabled: true) }

    before { allow(fake_repo).to receive(:by_id).with(2).and_return(user) }

    context "user id in session" do
      let(:env) { {"rack.session" => {user_id: 2}} }

      it "returns user" do
        expect(subject).to eq(user)
      end
    end

    context "session empty" do
      let(:env) { {"rack.session" => {}} }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
