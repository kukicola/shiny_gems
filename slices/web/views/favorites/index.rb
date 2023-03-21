# frozen_string_literal: true

module Web
  module Views
    module Favorites
      class Index < Web::View
        config.template = "favorites/index"
        config.title = "Favorites - ShinyGems"

        expose :gems
      end
    end
  end
end
