# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class Create < ShinyGems::Action
        include Deps["services.gems.create", "actions.gems.new", "errors_mapper",
          view: "views.gems.new_view", view_context: "views.app_context"]

        before :require_user!
        before :validate_params

        params do
          required(:repository).filled(:string)
        end

        def handle(request, response)
          repos = create.call(user: response[:current_user], repo: request.params[:repository])

          if repos.success?
            # TODO: redirect to issues edit
            response.redirect_to("/gems/#{repos.value!.id}")
          else
            response[:error] = errors_mapper.call(repos.failure)
            response[:current_repo] = request.params[:repository]
            new.handle(request, response)
          end
        end

        private

        def validate_params(request, response)
          return if request.params.valid?

          new.handle(request, response)
          throw :halt
        end
      end
    end
  end
end
