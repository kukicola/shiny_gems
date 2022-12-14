# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class New < ShinyGems::Action
        include Deps["services.github.repos_list", "errors_mapper",
          view: "views.gems.new_view", view_context: "views.app_context"]

        before :require_user!

        def handle(request, response)
          repos = repos_list.call(response[:current_user])

          if repos.success?
            response[:repos] = repos.value!
          else
            response.flash[:warning] = errors_mapper.call(repos.failure)
            response.redirect_to("/gems/mine")
          end
        end
      end
    end
  end
end
