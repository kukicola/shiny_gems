# frozen_string_literal: true

module ShinyGems
  class Routes < Hanami::Routes
    slice :web, at: "/" do
      require "sidekiq/web"
      require "sidekiq/cron/web"
      require "omniauth"
      require "omniauth-github"

      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Hanami.app["settings"].sidekiq_web_user)) &
          Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Hanami.app["settings"].sidekiq_web_pass))
      end
      mount Sidekiq::Web, at: "/sidekiq"

      use OmniAuth::Builder do
        configure do |config|
          config.request_validation_phase = Web::Action.new
        end
        provider :github, Hanami.app["settings"].github_key, Hanami.app["settings"].github_secret, scope: "user:email"
      end

      root to: "pages.index"
      get "privacy", to: "pages.privacy"

      scope "auth" do
        get ":provider/callback", to: "session.create"
        get "destroy", to: "session.destroy"
        get "failure", to: "session.failure"
      end

      scope "gems" do
        get "/", to: "gems.index"
        get "/:id", id: /\d+/, to: "gems.show_old"
        get "/:name", to: "gems.show"
        post "/:name/favorite", to: "favorites.create"
        post "/:name/unfavorite", to: "favorites.delete"
      end
      post "/gemfile", to: "gemfile.create"
      scope "favorites" do
        get "/", to: "favorites.index"
      end

      get "/*any", to: "pages.not_found"
    end
  end
end
