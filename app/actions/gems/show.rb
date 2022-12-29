# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class Show < ShinyGems::Action
        include Deps["repositories.gems_repository"]

        def handle(request, response)
          gem = gems_repository.by_id(request.params[:id], with: [:issues, :user])
          raise NotFoundError unless gem

          response[:current_gem] = gem
        end
      end
    end
  end
end
