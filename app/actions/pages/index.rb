# frozen_string_literal: true

module ShinyGems
  module Actions
    module Pages
      class Index < ShinyGems::Action
        include Deps[view: "views.pages.index_view", view_context: "views.app_context"]
      end
    end
  end
end
