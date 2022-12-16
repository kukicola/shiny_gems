# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      module Issues
        class Edit < ShinyGems::Action
          include Deps["services.github.issues_list_fetcher", "errors_mapper"]

          before :require_user!

          include Mixins::GemAction

          # TODO: select issues that are already in DB
          def handle(request, response)
            issues = issues_list_fetcher.call(response[:current_gem].repo)

            if issues.success?
              response[:issues] = issues.value!
            else
              response.flash[:warning] = errors_mapper.call(issues.failure)
              response.redirect_to("/gems/#{response[:current_gem].id}")
            end
          end
        end
      end
    end
  end
end
