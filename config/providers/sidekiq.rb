# frozen_string_literal: true

Hanami.app.register_provider :sidekiq do
  prepare do
    require "sidekiq"
  end

  start do
    Sidekiq.configure_server do |config|
      config.redis = {url: target["settings"].redis_url}
    end

    Sidekiq.configure_client do |config|
      config.redis = {url: target["settings"].redis_url}
    end
  end
end
