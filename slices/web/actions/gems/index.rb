# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class Index < Web::Action
        include Deps["repositories.gems_repository"]

        before :validate_params!

        DEFAULT_PARAMS = {
          page: 1
        }.freeze

        params do
          optional(:page).filled(:integer)
        end

        def handle(request, response)
          params = DEFAULT_PARAMS.merge(request.params.to_h)

          result = gems_repository.index(page: params[:page])
          response[:gems] = result.to_a
          response[:pager] = result.pager
        end
      end
    end
  end
end
