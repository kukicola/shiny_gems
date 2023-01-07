# frozen_string_literal: true

require "sidekiq"
require "sentry-sidekiq"
require "sidekiq-cron"
require "hanami/boot"

Sidekiq.configure_server do |c|
  c.redis = {url: Hanami.app["settings"].redis_url}
end

Sidekiq.configure_client do |c|
  c.redis = {url: Hanami.app["settings"].redis_url}
end
