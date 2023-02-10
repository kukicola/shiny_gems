# frozen_string_literal: true

module ShinyGems
  class Routes < Hanami::Routes
    slice :web, at: "/" do
      require "sidekiq/web"
      require "sidekiq/cron/web"

      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Hanami.app["settings"].sidekiq_web_user)) &
          Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Hanami.app["settings"].sidekiq_web_pass))
      end
      mount Sidekiq::Web, at: "/sidekiq"

      root to: "pages.index"

      scope "gems" do
        get "/", to: "gems.index"
        get "/:id", to: "gems.show"
        post "/gemfile", to: "gems.gemfile.create"
      end

      get "/*any", to: "pages.not_found"
    end
  end
end
