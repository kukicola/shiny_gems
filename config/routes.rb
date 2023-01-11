# frozen_string_literal: true

module ShinyGems
  class Routes < Hanami::Routes
    slice :web, at: "/" do
      require "sidekiq/web"
      require "sidekiq/cron/web"

      # TODO: add basic auth
      mount Sidekiq::Web, at: "/sidekiq"

      root to: "pages.index"

      scope "gems" do
        get "/", to: "gems.index"
        get "/:id", to: "gems.show"
        post "/gemfile", to: "gems.gemfile.create"
      end
    end
  end
end
