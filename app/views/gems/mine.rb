# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class Mine < ShinyGems::View
        config.template = "gems/mine"
        config.title = "My gems - ShinyGems"

        expose :gems
      end
    end
  end
end
