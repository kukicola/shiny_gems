# frozen_string_literal: true

module ShinyGems
  module Actions
    module Gems
      class Index < ShinyGems::Action
        include Deps["repositories.gems_repository", view: "views.gems.index_view", view_context: "views.app_context"]

        DEFAULT_PARAMS = {
          page: 1,
          sort_by: "name"
        }.freeze

        SORTING_DIRECTIONS = {
          "name" => "asc",
          "stars" => "desc",
          "downloads" => "desc"
        }.freeze

        params do
          optional(:page).filled(:integer)
          optional(:sort_by).filled(:string, included_in?: SORTING_DIRECTIONS.keys)
        end

        def handle(request, response)
          params = request.params.valid? ? DEFAULT_PARAMS.merge(request.params.to_h) : DEFAULT_PARAMS

          response[:gems] = gems_repository.index(page: params[:page], order: params[:sort_by], order_dir: SORTING_DIRECTIONS[params[:sort_by]])
          response[:pager] = response[:gems].pager
          response[:sort_by] = params[:sort_by]
        end
      end
    end
  end
end
