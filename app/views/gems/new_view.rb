# frozen_string_literal: true

module ShinyGems
  module Views
    module Gems
      class NewView < ShinyGems::View
        include Deps["services.github.repos_list"]

        config.template = "gems/new"

        expose :repos do |current_user:|
          repos_list.call(current_user).value!
        end
      end
    end
  end
end
