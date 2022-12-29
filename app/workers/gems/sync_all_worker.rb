# frozen_string_literal: true

module ShinyGems
  module Workers
    module Gems
      class SyncAllWorker < ShinyGems::Worker
        include Deps["workers.gems.sync_worker", "workers.gems.sync_issues_worker", "repositories.gems_repository"]

        def perform
          gems_repository.pluck_ids.each do |id|
            sync_worker.perform_async(id)
            sync_issues_worker.perform_async(id)
          end
        end
      end
    end
  end
end
