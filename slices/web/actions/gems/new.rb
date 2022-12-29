# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class New < Web::Action
        include Deps["core.services.github.repos_list_fetcher", "errors_mapper"]

        before :require_user!

        def handle(request, response)
          repos = repos_list_fetcher.call(response[:current_user])

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
