# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      module Issues
        class Edit < ShinyGems::View
          config.template = "gems/issues/edit"

          expose :current_gem, :issues
        end
      end
    end
  end
end
