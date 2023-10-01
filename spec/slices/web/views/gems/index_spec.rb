# frozen_string_literal: true

RSpec.describe Web::Views::Gems::Index do
  describe "pages exposure" do
    subject { described_class.new.call(pager: fake_pager, sort_by: "downloads", gems: [], context: context) }

    let(:context) { Web::Views::Context.new.with(request: request_dbl, response: response_dbl) }
    let(:response_dbl) { instance_double(Hanami::Action::Response, flash: []) }
    let(:request_dbl) { instance_double(Hanami::Action::Request, session: {}, flash: {}) }
    let(:fake_pager) { instance_double(ROM::SQL::Plugin::Pagination::Pager, current_page: 5, total_pages: 25) }

    before do
      allow(response_dbl).to receive(:[]).with(:current_user).and_return(nil)
    end

    it "returns array with proper gaps" do
      expect(subject[:pages]).to eq([1, :gap, 4, 5, 6, :gap, 25])
    end
  end
end
