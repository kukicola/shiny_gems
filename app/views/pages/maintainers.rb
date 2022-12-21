# frozen_string_literal: true

module ShinyGems
  module Views
    module Pages
      class Maintainers < ShinyGems::View
        config.template = "pages/maintainers"
        config.title = "For maintainers - ShinyGems"
        config.description = "Add your gems and get some help with bugs or features from passionate developers."
      end
    end
  end
end
