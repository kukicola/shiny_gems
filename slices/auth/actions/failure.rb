# frozen_string_literal: true

module Auth
  module Actions
    class Failure < Auth::Action
      def handle(_request, response)
        response.flash[:warning] = "Error: couldn't sign in"
        response.redirect_to("/")
      end
    end
  end
end
