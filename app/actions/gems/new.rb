# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class New < ShinyGems::Action
        include Deps[view: "views.gems.new_view", view_context: "views.app_context"]
      end
    end
  end
end
