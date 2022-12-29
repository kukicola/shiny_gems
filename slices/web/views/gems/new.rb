# frozen_string_literal: true

module Web
  module Views
    module Gems
      class New < Web::View
        config.template = "gems/new"
        config.title = "Add new gem - ShinyGems"

        expose :repos, :error, :current_repo
      end
    end
  end
end
