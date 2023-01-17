# frozen_string_literal: true

module Web
  module Actions
    module Gems
      class Index < Web::Action
        include Deps["repositories.gems_repository"]

        before :validate_params!

        DEFAULT_PARAMS = {
          page: 1,
          sort_by: "downloads"
        }.freeze

        SORTING_DIRECTIONS = ["name", "stars", "downloads"].freeze

        params do
          optional(:page).filled(:integer)
          optional(:sort_by).filled(:string, included_in?: SORTING_DIRECTIONS)
        end

        def handle(request, response)
          params = DEFAULT_PARAMS.merge(request.params.to_h)

          result = gems_repository.index(page: params[:page], order: params[:sort_by])
          response[:gems] = result.to_a
          response[:pager] = result.pager
          response[:sort_by] = params[:sort_by]
        end
      end
    end
  end
end
