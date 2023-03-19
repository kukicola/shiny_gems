# frozen_string_literal: true

module Web
  module Actions
    module Session
      class Failure < Web::Action
        def handle(_request, response)
          response.flash[:warning] = "Error: couldn't sign in"
          response.redirect_to("/")
        end
      end
    end
  end
end
