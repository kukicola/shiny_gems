# frozen_string_literal: true

module ShinyGems
  module Services
    module Gems
      class Sync < ShinyGems::Service
        include Deps["services.gems.rubygems_info", "services.github.repo", "repositories.gems_repository"]

        def call(gem)
          info = yield rubygems_info.call(gem.name)
          github_info = yield repo.call(gem.repo)

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
