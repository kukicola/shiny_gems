# frozen_string_literal: true

module ShinyGems
  class Settings < Hanami::Settings
    setting :github_key, constructor: Types::String
    setting :github_secret, constructor: Types::String
    setting :session_secret, constructor: Types::String
  end
end
