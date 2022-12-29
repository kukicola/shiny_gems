# frozen_string_literal: true

module ShinyGems
  module Actions
    module Session
      class Failure < ShinyGems::Action
        def handle(_request, response)
          response.flash[:warning] = "Error: couldn't sign in"
          response.redirect_to("/")
        end
      end
    end
  end
end
