# frozen_string_literal: true

module Web
  module Actions
    module Gems
      module Issues
        class Edit < Web::Action
          include Deps["core.services.github.issues_list_fetcher", "errors_mapper"]

          before :require_user!

          include Mixins::GemAction

          def handle(request, response)
            issues = issues_list_fetcher.call(response[:current_gem].repo)

            if issues.success?
              response[:issues] = mark_selected!(issues.value!, response[:current_gem])
            else
              response.flash[:warning] = errors_mapper.call(issues.failure)
              response.redirect_to("/gems/#{response[:current_gem].id}")
            end
          end

          private

          def mark_selected!(issues, gem)
            issues_in_db = gem.issues.map(&:github_id)
            issues.each do |issue|
              issue[:selected] = issues_in_db.include?(issue[:id])
            end
          end
        end
      end
    end
  end
end
