# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class Show < Web::Action
        include Deps["repositories.gems_repository"]

        def handle(request, response)
          gem = gems_repository.by_id(request.params[:id], with: {repo: :issues})
          raise NotFoundError unless gem

          response[:current_gem] = gem
        end
      end
    end
  end
end
