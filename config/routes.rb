# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"
require_relative "../lib/shiny_gems/admin_middleware"

Sidekiq::Web.use ShinyGems::AdminMiddleware

module ShinyGems
  class Routes < Hanami::Routes
    mount Sidekiq::Web, at: "/admin/sidekiq"

    slice :auth, at: "auth" do
      use OmniAuth::Builder do
        provider :github, Hanami.app["settings"].github_key, Hanami.app["settings"].github_secret, scope: "read:org"
      end

      get ":provider/callback", to: "create"
      get "destroy", to: "destroy"
      get "failure", to: "failure"
    end

    slice :web, at: "/" do
      use Rack::Static, {urls: ["/assets", "/favicon.ico"], root: "public"}
      use :body_parser, :form

      root to: "pages.index"
      get "/maintainers", to: "pages.maintainers"

      scope "gems" do
        get "/", to: "gems.index"
        get "/:id", to: "gems.show"
        get "new", to: "gems.new"
        post "/", to: "gems.create"
        post "/gemfile", to: "gems.gemfile.create"

        get "mine", to: "gems.mine"
        post ":id/destroy", to: "gems.destroy"
        get ":id/issues/edit", to: "gems.issues.edit"
        post ":id/issues", to: "gems.issues.update"
      end
    end
  end
end
