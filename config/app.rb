# frozen_string_literal: true

require "hanami"
require "omniauth"
require "omniauth-github"

module ShinyGems
  class App < Hanami::App
    config.actions.sessions = :cookie, {
      key: "session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365
    }

    config.actions.content_security_policy[:form_action] += " https://github.com"

    config.middleware.use Rack::Static, {urls: ["/assets"], root: "public"}
    config.middleware.use OmniAuth::Builder do
      provider :github, Hanami.app["settings"].github_key, Hanami.app["settings"].github_secret, scope: 'user:email'
    end
  end
end
