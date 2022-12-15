# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      module Issues
        class Edit < ShinyGems::Action
          include Deps["services.github.issues_list", "errors_mapper",
            view: "views.gems.issues.edit_view", view_context: "views.app_context"]

          before :require_user!
          before :load_gem_and_check_ownership!

          def handle(request, response)
            issues = issues_list.call(response[:current_gem].repo)

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
