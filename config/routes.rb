# frozen_string_literal: true

require "sidekiq/web"
require_relative "../app/lib/admin_middleware"

Sidekiq::Web.use ShinyGems::AdminMiddleware

module ShinyGems
  class Routes < Hanami::Routes
    mount Sidekiq::Web, at: "/admin/sidekiq"

    root to: "pages.index"
    get "/maintainers", to: "pages.maintainers"

    scope "auth" do
      get ":provider/callback", to: "session.create"
      get "destroy", to: "session.destroy"
      get "failure", to: "session.failure"
    end

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
