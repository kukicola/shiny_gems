# frozen_string_literal: true

module Processing
  module Workers
    class DiscoverWorker < Processing::Worker
      include Deps["workers.sync_worker", "workers.sync_issues_worker", "services.discover"]

      # TODO: specs
      def perform(page = 1)
        result = discover.call(page: page)

        case result
        in Dry::Monads::Success[*gems]
          gems.each do |gem|
            sync_worker.perform_async(gem.id)
            # TODO: create or find repo and sync it
            #sync_issues_worker.perform_async(gem.id)
          end
          self.class.perform_async(page + 1)
        in Dry::Monads::Failure(StandardError => exception)
          raise exception
        in Dry::Monads::Failure(:no_results)
          return
        end
      end
    end
  end
end
