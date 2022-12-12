# frozen_string_literal: true

require "hanami"
require "omniauth"
require "omniauth-github"
require "sidekiq"

module ShinyGems
  Workers = Module.new

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

    prepare_container do
      Sidekiq.configure_server do |c|
        c.redis = {url: Hanami.app["settings"].redis_url}
      end

      Sidekiq.configure_client do |c|
        c.redis = {url: Hanami.app["settings"].redis_url}
      end
    end

    class << self
      private

      def prepare_app_component_dirs
        container.config.component_dirs.add("app/workers") do |dir|
          dir.namespaces.add_root(key: "workers", const: "ShinyGems::Workers")
          dir.instance = proc do |component|
            component.loader.constant(component)
          end
        end

        super
      end
    end
  end
end

# TODO: sync workers & rake tasks
# TODO: add gem form
