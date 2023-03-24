# frozen_string_literal: true

module Web
  module Views
    module Gems
      class Show < Web::View
        config.template = "gems/show"

        expose :current_gem, as: :gem
        expose :total_favorites
        expose :favorite

        expose :seo_title, layout: true do |current_gem:|
          "#{current_gem.name} - ShinyGems"
        end
      end
    end
  end
end
