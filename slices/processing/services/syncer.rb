# frozen_string_literal: true

module Processing
  module Services
    class Syncer < ShinyGems::Service
      include Deps["services.rubygems.gem_fetcher", "services.github.repo_fetcher", "repositories.gems_repository"]

      def call(gem)
        info = yield gem_fetcher.call(gem.name)
        github_info = yield repo_fetcher.call(gem.repo)

        attributes = {
          description: info["info"],
          stars: github_info["stargazers_count"],
          downloads: info["downloads"]
        }

        Success(gems_repository.update(gem.id, attributes))
      end
    end
  end
end
