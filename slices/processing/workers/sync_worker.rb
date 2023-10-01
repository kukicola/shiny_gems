# frozen_string_literal: true

module Processing
  module Workers
    class SyncWorker < Processing::Worker
      include Deps["services.syncer", "repositories.gems_repository"]

      def perform(gem_id)
        gem = gems_repository.by_id(gem_id)
        result = syncer.call(gem)

        case result
        in Dry::Monads::Success
          return
        in Dry::Monads::Failure[Gems::NotFound]
          gems_repository.delete(gem_id)
        else
          raise result.failure
        end
      end
    end
  end
end
