# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class Index < ShinyGems::View
        config.template = "gems/index"
        config.title = "Browse gems - ShinyGems"

        expose :gems, :pager, :sort_by
      end
    end
  end
end
