# frozen_string_literal: true

module Web
  module Actions
    module Favorites
      class Index < Web::Action
        include Deps["repositories.gems_repository"]

        before :require_user!

        def handle(request, response)
          response[:gems] = gems_repository.user_favorites(response[:current_user].id)
        end
      end
    end
  end
end
