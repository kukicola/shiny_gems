# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class Mine < ShinyGems::Action
        include Deps["repositories.gems_repository"]

        before :require_user!

        def handle(request, response)
          response[:gems] = gems_repository.belonging_to_user(response[:current_user].id)
        end
      end
    end
  end
end
