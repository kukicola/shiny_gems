# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class Show < ShinyGems::View
        config.template = "gems/show"

        expose :current_gem, as: :gem

        expose :seo_title, layout: true do |current_gem:|
          "#{current_gem.name} - ShinyGems"
        end
      end
    end
  end
end
