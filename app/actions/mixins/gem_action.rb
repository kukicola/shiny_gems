# frozen_string_literal: true

module ShinyGems
  module Actions
    module Mixins
      module GemAction
        def self.included(action_class)
          action_class.include Deps["repositories.gems_repository"]

          action_class.before :load_gem_and_check_ownership!
        end

        private

        def load_gem_and_check_ownership!(request, response)
          id = request.params[:id]
          gem = gems_repository.by_id(id, with: [:issues])

          raise ShinyGems::Action::NotFoundError unless gem
          raise ShinyGems::Action::ForbiddenError unless gem.user_id == response[:current_user].id

          response[:current_gem] = gem
        end
      end
    end
  end
end
