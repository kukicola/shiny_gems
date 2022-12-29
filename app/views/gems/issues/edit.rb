# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      module Issues
        class Edit < ShinyGems::View
          config.template = "gems/issues/edit"
          config.title = "Edit issues - ShinyGems"

          expose :current_gem, :issues
        end
      end
    end
  end
end
