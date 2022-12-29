# frozen_string_literal: true

require "hanami"
require "sidekiq"

module ShinyGems
  class App < Hanami::App
    config.shared_app_component_keys += [
      "sentry",
      "repositories.users_repository",
      "repositories.gems_repository",
      "repositories.issues_repository"
    ]

    config.actions.sessions = :cookie, {
      key: "session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365
    }

    Sidekiq.configure_client do |c|
      c.redis = {url: settings.redis_url}
    end

    Sidekiq.configure_server do |c|
      c.redis = {url: settings.redis_url}
    end
  end
end
