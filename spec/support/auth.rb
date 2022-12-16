# frozen_string_literal: true

RSpec.shared_context "authorized user" do
  let!(:user) { Factory.structs[:user] }
  let!(:fake_auth_repo) do
    fake_repository(:users, stub_container: true) do |repo|
      allow(repo).to receive(:by_id).with(user.id).and_return(user)
    end
  end
  let!(:env) { {"rack.session" => {user_id: user.id}} }
end
