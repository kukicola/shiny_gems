# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      module Gemfile
        class Create < ShinyGems::View
          config.template = "gems/gemfile/create"

          expose :gems
        end
      end
    end
  end
end
