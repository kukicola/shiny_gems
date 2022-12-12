# frozen_string_literal: true

desc "Enqueue sync all gems"
namespace :gems do
  task sync_all: :environment do
    Hanami.app["workers.gems.sync_all_job"].perform_async
  end
end
