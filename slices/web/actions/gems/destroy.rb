# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class Destroy < Web::Action
        include Deps["repositories.gems_repository"]

        include Mixins::GemAction

        def handle(request, response)
          gems_repository.delete(response[:current_gem].id)

          response.flash[:success] = "Gem removed"
          response.redirect_to("/gems/mine")
        end
      end
    end
  end
end
