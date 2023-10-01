# frozen_string_literal: true

module Processing
  module Services
    class RepoSyncer < ShinyGems::Service
      include Deps["services.github.repo_fetcher", "repositories.repos_repository",
        "repositories.gems_repository", "workers.sync_issues_worker"]

      def call(repo)
        info = yield repo_fetcher.call(repo.name)

        attributes = {
          stars: info[:stargazers_count],
          pushed_at: info[:pushed_at]
        }

        if info[:full_name] == repo.name
          Success(repos_repository.update(repo.id, attributes))
        else
          repos_repository.transaction do
            new_repo = repos_repository.find_or_create({name: info[:full_name]})
            gems_repository.replace_repo(repo.id, new_repo.id)
            repos_repository.delete(repo.id)
            Success(repos_repository.update(new_repo.id, attributes))
          end
        end
      end
    end
  end
end
