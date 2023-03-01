# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class Show < Web::Action
        include Deps["repositories.gems_repository"]

        before :validate_params!

        params do
          required(:name).filled(:string)
        end

        def handle(request, response)
          gem = gems_repository.by_name(request.params[:name], with: {repo: [:issues, :gems]})
          raise NotFoundError unless gem

          response[:current_gem] = gem
        end
      end
    end
  end
end
