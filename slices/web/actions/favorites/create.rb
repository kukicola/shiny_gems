# frozen_string_literal: true

module Web
  module Actions
    module Favorites
      class Create < Web::Action
        include Deps["repositories.gems_repository", "repositories.favorites_repository"]

        before :require_user!
        before :validate_params!

        params do
          required(:name).filled(:string)
        end

        def handle(request, response)
          gem = gems_repository.by_name(request.params[:name])
          raise NotFoundError unless gem

          favorites_repository.create(gem_id: gem.id, user_id: response[:current_user].id)

          response.flash[:success] = "Gem added to favorites"
          response.redirect_to("/gems/#{gem.name}")
        end
      end
    end
  end
end
