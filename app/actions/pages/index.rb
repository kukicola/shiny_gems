# frozen_string_literal: true

module ShinyGems
  module Actions
    module Pages
      class Index < ShinyGems::Action
        include Deps[view: "views.pages.index", view_context: "views.app_context"]

        def handle(request, response)
        end
      end
    end
  end
end
