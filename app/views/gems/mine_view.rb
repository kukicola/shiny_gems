# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class MineView < ShinyGems::View
        config.template = "gems/mine"

        expose :gems
      end
    end
  end
end
