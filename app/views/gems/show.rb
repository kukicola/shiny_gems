# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class Show < ShinyGems::View
        config.template = "gems/show"

        expose :current_gem, as: :gem
      end
    end
  end
end
