# frozen_string_literal: true

module ShinyGems
  class Settings < Hanami::Settings
    setting :github_key, constructor: Types::String.optional
    setting :github_secret, constructor: Types::String.optional
    setting :database_url, constructor: Types::String.optional
    setting :redis_url, constructor: Types::String.optional
    setting :sentry_url, constructor: Types::String.optional
    setting :host, constructor: Types::String.optional
    setting :session_secret, constructor: Types::String.optional
    setting :sidekiq_web_user, constructor: Types::String.optional
    setting :sidekiq_web_pass, constructor: Types::String.optional
  end
end
