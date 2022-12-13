# frozen_string_literal: true

module ShinyGems
  class AdminMiddleware
    include Deps["repositories.users_repository"]

    def initialize(app, deps)
      @app = app
      @user_repository = deps[:users_repository]
    end

    def call(env)
      user = env["rack.session"][:user_id] && @user_repository.by_id(env["rack.session"][:user_id])

      if user&.admin
        @app.call(env)
      else
        [403, {"Content-Type" => "text/plain"}, ["Forbidden"]]
      end
    end
  end
end
