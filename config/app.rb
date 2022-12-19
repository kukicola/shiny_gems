# frozen_string_literal: true

require "hanami"
require "omniauth"
require "omniauth-github"
require "sidekiq"

module ShinyGems
  class App < Hanami::App
    config.actions.sessions = :cookie, {
      key: "session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365
    }

    config.actions.content_security_policy[:form_action] += " https://github.com"
    config.actions.content_security_policy[:script_src] += " https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
    config.actions.content_security_policy[:font_src] += " https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/fonts/"

    config.middleware.use Rack::Static, {urls: ["/assets", "/favicon.ico"], root: "public"}

    config.middleware.use OmniAuth::Builder do
      provider :github, Hanami.app["settings"].github_key, Hanami.app["settings"].github_secret, scope: "read:org"
    end

    config.middleware.use :body_parser, :form

    Sidekiq.configure_server do |c|
      c.redis = {url: settings.redis_url}
    end

    Sidekiq.configure_client do |c|
      c.redis = {url: settings.redis_url}
    end

    prepare_container do |container|
      container.config.component_dirs.dir("app") do |dir|
        dir.instance = proc do |component|
          if component.key.match?(/workers\./)
            component.loader.constant(component)
          else
            component.loader.call(component)
          end
        end
      end
    end
  end
end

# TODO: feature specs
# TODO: homepage
# TODO: for mainteners
# TODO: footer
# TODO: responsivnes
# TODO: seo
# TODO: deploy stuff - sentry, configs, timeouts
