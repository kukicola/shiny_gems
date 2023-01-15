# frozen_string_literal: true

module Processing
  module Workers
    class SyncAllWorker < Processing::Worker
      include Deps["workers.sync_worker", "workers.sync_issues_worker", "workers.sync_repo_worker",
        "repositories.gems_repository", "repositories.repos_repository"]

      # TODO: split sync across the day
      def perform
        gems_repository.pluck_ids.each do |id|
          sync_worker.perform_async(id)
        end

        repos_repository.pluck_ids.each do |id|
          sync_repo_worker.perform_async(id)
          sync_issues_worker.perform_async(id)
        end
      end
    end
  end
end
