# frozen_string_literal: true

module Processing
  module Services
    module Rubygems
      class ListFetcher < ShinyGems::Service
        include Deps["gems_api"]

        MIN_DOWNLOADS = 1_000_000

        def call(page: 1)
          Success(gems_api.search("downloads:>#{MIN_DOWNLOADS}", {page: page}))
        rescue ::Gems::GemError => e
          Failure(e)
        end
      end
    end
  end
end
