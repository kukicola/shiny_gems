# frozen_string_literal: true

RSpec.describe "Root", type: :request do
  it "is successful" do
    get "/"

    expect(last_response).to be_successful
    expect(last_response.body).to include("ShinyGems")
  end
end
