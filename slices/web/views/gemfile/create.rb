# frozen_string_literal: true

module Web
  module Views
    module Gemfile
      class Create < Web::View
        config.template = "gemfile/create"
        config.title = "Gems from your Gemfile - ShinyGems"

        expose :gems
      end
    end
  end
end
