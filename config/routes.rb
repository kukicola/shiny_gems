# frozen_string_literal: true

module ShinyGems
  class Routes < Hanami::Routes
    root to: "pages.index"
    get "auth/:provider/callback", to: "session.create"
    get "auth/destroy", to: "session.destroy"
    get "auth/failure", to: "session.failure"
  end
end
