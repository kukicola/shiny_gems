# frozen_string_literal: true

module Processing
  module Services
    module Rubygems
      class GemFetcher < ShinyGems::Service
        include Deps["gems_api"]

        def call(name)
          Success(gems_api.info(name))
        rescue ::Gems::GemError => e
          Failure(e)
        end
      end
    end
  end
end
