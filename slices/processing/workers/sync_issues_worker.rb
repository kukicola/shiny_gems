# frozen_string_literal: true

module Processing
  module Workers
    class SyncIssuesWorker < Processing::Worker
      include Deps["repositories.gems_repository", "services.issues_syncer"]

      def perform(gem_id)
        gem = gems_repository.by_id(gem_id, with: [:issues])
        result = issues_syncer.call(gem)

        raise result.failure if !result.success? && !result.failure.is_a?(Octokit::NotFound)
      end
    end
  end
end
