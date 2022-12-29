# frozen_string_literal: true

module Core
  module Services
    module Gems
      class Syncer < Core::Service
        include Deps["services.gems.rubygems_info_fetcher", "services.github.repo_fetcher", "repositories.gems_repository"]

        def call(gem)
          info = yield rubygems_info_fetcher.call(gem.name)
          github_info = yield repo_fetcher.call(gem.repo)

          attributes = {
            description: info["info"],
            stars: github_info[:stargazers_count],
            downloads: info["downloads"]
          }

          Success(gems_repository.update(gem.id, attributes))
        end
      end
    end
  end
end
