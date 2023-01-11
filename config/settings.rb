# frozen_string_literal: true

module ShinyGems
  class Settings < Hanami::Settings
    setting :github_key, constructor: Types::String
    setting :github_secret, constructor: Types::String
    setting :database_url, constructor: Types::String
    setting :redis_url, constructor: Types::String
    setting :sentry_url, constructor: Types::String
    setting :host, constructor: Types::String
    setting :session_secret, constructor: Types::String
  end
end
