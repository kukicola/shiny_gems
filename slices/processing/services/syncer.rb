# frozen_string_literal: true

module Processing
  module Services
    # TODO: add similar for repo
    class Syncer < ShinyGems::Service
      include Deps["services.rubygems.gem_fetcher", "repositories.gems_repository"]

      def call(gem)
        info = yield gem_fetcher.call(gem.name)

        attributes = {
          description: info["info"],
          downloads: info["downloads"],
        }

        Success(gems_repository.update(gem.id, attributes))
      end
    end
  end
end
