# frozen_string_literal: true

module Web
  module Views
    module Pages
      class Maintainers < Web::View
        config.template = "pages/maintainers"
        config.title = "For maintainers - ShinyGems"
        config.description = "Add your gems and get some help with bugs or features from passionate developers."
      end
    end
  end
end
