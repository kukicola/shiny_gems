# frozen_string_literal: true

require "dry/system/stubs"

module ShinyGems
  module Support
    module Auth
      def with_user
        let(:user) { Factory.structs[:user] }
        let(:fake_auth_repo) { instance_double(ShinyGems::Repositories::UsersRepository) }
        let(:env) { {"rack.session" => {user_id: user.id}} }

        before do
          allow(fake_auth_repo).to receive(:by_id).with(user.id).and_return(user)
        end

        around do |example|
          Hanami.app.container.stub("repositories.users_repository", fake_auth_repo) do
            example.call
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.extend ShinyGems::Support::Auth
end
