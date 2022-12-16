# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      module Issues
        class Update < ShinyGems::Action
          include Deps["services.gems.issues.updater", "errors_mapper"]

          before :require_user!
          before :validate_params!

          include Mixins::GemAction

          params do
            required(:id).filled(:integer)
            optional(:issues_ids).array(:integer)
          end

          def handle(request, response)
            result = updater.call(gem: response[:current_gem], issues_ids: (request.params[:issues_ids] || []).map(&:to_i))

            if result.success?
              response.flash[:success] = "Issues saved"
            else
              response.flash[:warning] = errors_mapper.call(result.failure)
            end

            response.redirect_to("/gems/#{response[:current_gem].id}")
          end
        end
      end
    end
  end
end
