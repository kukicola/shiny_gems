# frozen_string_literal: true

require "hanami"

module ShinyGems
  class App < Hanami::App
    config.shared_app_component_keys += ["sentry", "persistence.rom"]

    # config.actions.sessions = :cookie, {
    #   key: "session",
    #   secret: settings.session_secret,
    #   expire_after: 60 * 60 * 24 * 365
    # }

    config.actions.content_security_policy[:form_action] += " https://github.com"
    config.actions.content_security_policy[:script_src] += " https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js https://static.cloudflareinsights.com/beacon.min.js/"
    config.actions.content_security_policy[:font_src] += " https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/fonts/"

    config.middleware.use Rack::Static, {urls: ["/assets", "/favicon.ico"], root: "public"}
    config.middleware.use :body_parser, :form

    config.assets.package_manager_run_command = "yarn run"
  end
end
