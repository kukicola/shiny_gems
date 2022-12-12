# frozen_string_literal: true

require "sidekiq/web"

module ShinyGems
  class Routes < Hanami::Routes
    mount Sidekiq::Web, at: "/admin/sidekiq"

    root to: "pages.index"
    get "auth/:provider/callback", to: "session.create"
    get "auth/destroy", to: "session.destroy"
    get "auth/failure", to: "session.failure"
  end
end
