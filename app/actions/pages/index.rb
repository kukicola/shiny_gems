# frozen_string_literal: true

module ShinyGems
  module Actions
    module Pages
      class Index < ShinyGems::Action
        include Deps["view": "views.pages.index"]

        def handle(_request, response)
          response.format = :html
          response.body = view.call
        end
      end
    end
  end
end
