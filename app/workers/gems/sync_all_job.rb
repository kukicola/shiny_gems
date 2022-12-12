# frozen_string_literal: true

module ShinyGems
  module Workers
    module Gems
      class SyncAllJob < ShinyGems::Worker
        include Deps["workers.gems.sync_job", gems_repository: "repositories.gems"]

        def perform
          gems_repository.pluck_ids.each do |id|
            sync_job.perform_async(id)
          end
        end
      end
    end
  end
end
