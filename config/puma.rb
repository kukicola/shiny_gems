# frozen_string_literal: true

require "sentry-sidekiq"

workers 2
threads 1, 3

port ENV.fetch("HANAMI_PORT", 2300)
environment ENV.fetch("HANAMI_ENV", "development")

preload_app!

before_fork do
  Hanami.shutdown
end

sidekiq = nil
on_worker_boot do
  sidekiq = Sidekiq.configure_embed do |config|
    require "sidekiq-cron"

    config.queues = %w[default]
    config.concurrency = 2
    config.redis = {url: Hanami.app["settings"].redis_url}
    config.on(:startup) do
      schedule_file = "config/schedule.yml"
      if File.exist?(schedule_file)
        Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
      end
    end
  end
  sidekiq.run
end

on_worker_shutdown do
  sidekiq&.stop
end

