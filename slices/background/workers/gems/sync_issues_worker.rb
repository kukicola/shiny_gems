# frozen_string_literal: true

module Background
  module Workers
    module Gems
      class SyncIssuesWorker < Background::Worker
        SyncError = Class.new(StandardError)

        include Deps["repositories.gems_repository", "core.services.gems.issues.updater"]

        def perform(gem_id)
          gem = gems_repository.by_id(gem_id, with: [:issues])
          result = updater.call(gem: gem, issues_ids: gem.issues.map(&:github_id))

          raise SyncError, result.failure unless result.success?
        end
      end
    end
  end
end
