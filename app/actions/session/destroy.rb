# frozen_string_literal: true

module ShinyGems
  module Actions
    module Session
      class Destroy < ShinyGems::Action
        def handle(_request, response)
          response.session.delete(:user_id)
          response.flash[:success] = "Successfully signed out"
          response.redirect_to("/")
        end
      end
    end
  end
end
