# frozen_string_literal: true

module ShinyGems
  module Actions
    class Root < ShinyGems::Action
      include Deps["view": "views.root"]

      def handle(request, response)
        response.format = :html
        response.body = view.call
      end
    end
  end
end
