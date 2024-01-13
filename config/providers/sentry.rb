# frozen_string_literal: true

Hanami.app.register_provider :sentry do
  prepare do
    require "sentry-ruby"
    require "sentry-sidekiq"

    Sentry.init do |config|
      config.dsn = target["settings"].sentry_url
    end
  end

  start do
    register "sentry", Sentry
  end
end
