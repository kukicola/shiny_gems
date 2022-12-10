# frozen_string_literal: true

module ShinyGems
  module Views
    class AppContext < Hanami::View::Context
      include Deps[users_repository: "repositories.users"]

      def current_user
        return @_current_user if defined?(@_current_user)

        @_current_user = users_repository.by_id(session[:user_id])
      end
    end
  end
end
