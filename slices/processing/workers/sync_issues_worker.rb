# frozen_string_literal: true

module Processing
  module Workers
    class SyncIssuesWorker < Processing::Worker
      include Deps["repositories.repos_repository", "services.issues_syncer"]

      def perform(repo_id)
        repo = repos_repository.by_id(repo_id, with: [:issues])
        result = issues_syncer.call(repo)

        raise result.failure if !result.success? && ![Octokit::NotFound, Octokit::Forbidden].include?(result.failure.class)
      end
    end
  end
end
