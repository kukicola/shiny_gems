# frozen_string_literal: true

module Processing
  module Services
    module Gems
      class ListFetcher < ShinyGems::Service
        include Deps["gems_api"]

        MIN_DOWNLOADS = 1_000_000

        def call(page: 1)
          Success(gems_api.search("downloads:>#{MIN_DOWNLOADS}", {page: page}))
        rescue ::Gems::GemError
          Failure(:gem_info_fetch_failed)
        end
      end
    end
  end
end
