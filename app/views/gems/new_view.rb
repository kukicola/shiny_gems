# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class NewView < ShinyGems::View
        include Deps["services.github.repos_list"]

        config.template = "gems/new"

        expose :repos
      end
    end
  end
end
