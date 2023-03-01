# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class ShowOld < Web::Action
        include Deps["repositories.gems_repository"]

        before :validate_params!

        params do
          required(:id).filled(:integer)
        end

        def handle(request, response)
          gem = gems_repository.by_id(request.params[:id])
          response.redirect_to("/gems/#{gem.name}", status: 301)
        end
      end
    end
  end
end
