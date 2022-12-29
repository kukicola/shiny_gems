# frozen_string_literal: true

module Core
  module Services
    module Gems
      class RubygemsInfoFetcher < Core::Service
        include Deps["gems_api"]

        def call(name)
          Success(gems_api.info(name))
        rescue ::Gems::GemError
          Failure(:gem_info_fetch_failed)
        end
      end
    end
  end
end
