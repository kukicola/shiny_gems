# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class New < ShinyGems::View
        config.template = "gems/new"

        expose :repos, :error, :current_repo
      end
    end
  end
end
