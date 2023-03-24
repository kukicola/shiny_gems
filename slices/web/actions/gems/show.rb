# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class Show < Web::Action
        include Deps["repositories.gems_repository", "repositories.favorites_repository"]

        before :validate_params!

        params do
          required(:name).filled(:string)
        end

        def handle(request, response)
          gem = gems_repository.by_name(request.params[:name], with: {repo: [:issues, :gems]})
          raise NotFoundError unless gem

          response[:current_gem] = gem
          response[:favorite] = if response[:current_user]
            favorites_repository.favorite?(user_id: response[:current_user].id, gem_id: gem.id)
          else
            false
          end
          response[:total_favorites] = favorites_repository.total_favorites(gem.id)
        end
      end
    end
  end
end
