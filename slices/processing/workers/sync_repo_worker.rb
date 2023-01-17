# frozen_string_literal: true

module Processing
  module Workers
    class SyncRepoWorker < Processing::Worker
      include Deps["services.repo_syncer", "repositories.repos_repository"]

      def perform(repo_id)
        repo = repos_repository.by_id(repo_id)
        result = repo_syncer.call(repo)

        raise result.failure if !result.success? && !result.failure.is_a?(Octokit::NotFound)
      end
    end
  end
end
