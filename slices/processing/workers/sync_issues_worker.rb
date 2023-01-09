# frozen_string_literal: true

module Processing
  module Workers
    class SyncIssuesWorker < Processing::Worker
      SyncError = Class.new(StandardError)

      include Deps["repositories.gems_repository", "services.issues_syncer"]

      def perform(gem_id)
        gem = gems_repository.by_id(gem_id, with: [:issues])
        result = issues_syncer.call(gem)

        raise SyncError, result.failure unless result.success?
      end
    end
  end
end
