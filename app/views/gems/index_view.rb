# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class IndexView < ShinyGems::View
        config.template = "gems/index"

        expose :gems, :pager, :sort_by
      end
    end
  end
end
