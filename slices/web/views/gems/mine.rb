# frozen_string_literal: true

module Web
  module Views
    module Gems
      class Mine < Web::View
        config.template = "gems/mine"
        config.title = "My gems - ShinyGems"

        expose :gems
      end
    end
  end
end
