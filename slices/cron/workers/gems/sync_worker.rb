# frozen_string_literal: true

module Cron
  module Workers
    module Gems
      class SyncWorker < Cron::Worker
        SyncError = Class.new(StandardError)

        include Deps["core.services.gems.syncer", "repositories.gems_repository"]

        def perform(gem_id)
          gem = gems_repository.by_id(gem_id)
          result = syncer.call(gem)
          raise SyncError, result.failure unless result.success?
        end
      end
    end
  end
end
