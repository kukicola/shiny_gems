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

    config.middleware.use Rack::Static, {urls: ["/assets", "/favicon.ico"], root: "public"}

    config.middleware.use OmniAuth::Builder do
      provider :github, Hanami.app["settings"].github_key, Hanami.app["settings"].github_secret, scope: "read:org"
    end
  end
end

# TODO: sidekiq integration
# TODO: sync workers & rake tasks
# TODO: add gem form
