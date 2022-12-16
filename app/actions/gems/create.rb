# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class Create < ShinyGems::Action
        include Deps["services.gems.creator", "actions.gems.new", "errors_mapper"]

        before :require_user!
        before :validate_params!

        params do
          required(:repository).filled(:string)
        end

        def handle(request, response)
          repos = creator.call(user: response[:current_user], repo: request.params[:repository])

          if repos.success?
            response.redirect_to("/gems/#{repos.value!.id}/issues/edit")
          else
            response[:error] = errors_mapper.call(repos.failure)
            response[:current_repo] = request.params[:repository]
            new.handle(request, response)
          end
        end
      end
    end
  end
end
