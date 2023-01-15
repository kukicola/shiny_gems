# frozen_string_literal: true

module Processing
  module Services
    class RepoSyncer < ShinyGems::Service
      include Deps["services.github.repo_fetcher", "repositories.repos_repository"]

      def call(repo)
        info = yield repo_fetcher.call(repo.name)

        # TODO: follow redirects to new organizations
        attributes = {
          stars: info[:stargazers_count],
          pushed_at: info[:pushed_at]
        }

        Success(repos_repository.update(repo.id, attributes))
      end
    end
  end
end
