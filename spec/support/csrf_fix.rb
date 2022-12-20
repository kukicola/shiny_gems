# frozen_string_literal: true

class RemoveCsrfParamMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) if env["CONTENT_TYPE"]&.start_with?("multipart")

    params = Rack::Utils.parse_query(env["rack.input"].read, "&")
    params.delete("_csrf_token")
    env["rack.input"] = StringIO.new(Rack::Utils.build_query(params))
    @app.call(env)
  end
end

class ShinyGems::App
  config.middleware.use RemoveCsrfParamMiddleware
end
