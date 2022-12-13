# frozen_string_literal: true

module ShinyGems
  module Workers
    module Gems
      class SyncWorker < ShinyGems::Worker
        SyncError = Class.new(StandardError)

        include Deps["services.gems.sync", "repositories.gems_repository"]

        def perform(gem_id)
          gem = gems_repository.by_id(gem_id)
          result = sync.call(gem)
          raise SyncError, result.failure unless result.success?
        end
      end
    end
  end
end
