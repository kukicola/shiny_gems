# frozen_string_literal: true

RSpec.describe Web::Views::Pages::Error do
  describe "exposures" do
    subject { described_class.new.call(code: 404, context: context) }

    let(:context) { Web::Views::Context.new.with(request: request_dbl, response: response_dbl) }
    let(:response_dbl) { instance_double(Hanami::Action::Response, flash: []) }
    let(:request_dbl) { instance_double(Hanami::Action::Request, session: {}) }

    before do
      allow(response_dbl).to receive(:[]).with(:current_user).and_return(nil)
    end

    it "exposes code and message" do
      expect(subject[:code].value).to eq(404)
      expect(subject[:msg].value).to eq("Not Found")
    end
  end
end
