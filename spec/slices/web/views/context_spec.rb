# frozen_string_literal: true

RSpec.describe Web::Views::Context do
  describe "#current_user" do
    subject { described_class.new(request: request, response: response).current_user }

    let(:request) { Hanami::Action::Request.new(env: {}, params: {}, sessions_enabled: true) }
    let(:response) { Hanami::Action::Response.new(request: request, config: {}, sessions_enabled: true) }
    let(:user) { Factory.structs[:user] }

    before do
      response[:current_user] = user
    end

    it "returns user from response exposures" do
      expect(subject).to eq(user)
    end
  end
end
