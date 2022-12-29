# frozen_string_literal: true

module Web
  module Views
    module Gems
      class Index < Web::View
        config.template = "gems/index"
        config.title = "Browse gems - ShinyGems"

        expose :gems, :pager, :sort_by
      end
    end
  end
end