# frozen_string_literal: true

module ShinyGems
  module Actions
    module Pages
      class Index < ShinyGems::Action
        include Deps[view: "views.pages.index"]

        def handle(request, response)

          response.render(view)
        end
      end
    end
  end
end
