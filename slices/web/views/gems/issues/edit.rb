# frozen_string_literal: true

module Web
  module Views
    module Gems
      module Issues
        class Edit < Web::View
          config.template = "gems/issues/edit"
          config.title = "Edit issues - ShinyGems"

          expose :current_gem, :issues
        end
      end
    end
  end
end
