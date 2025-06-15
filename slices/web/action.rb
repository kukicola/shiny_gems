# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module Web
  class Action < Hanami::Action
    include Deps["sentry", "settings", "views.pages.error", "views.pages.not_authorized", "repositories.users_repository"]

    BadRequestError = Class.new(StandardError)
    NotFoundError = Class.new(StandardError)

    handle_exception NotFoundError => :handle_not_found
    handle_exception BadRequestError => :handle_bad_request
    handle_exception StandardError => :handle_standard_error

    #before :check_host!
    before :set_current_user

    private

    def set_current_user(request, response)
      user_id = request.session[:user_id]
      response[:current_user] = user_id && users_repository.by_id(user_id)
    end

    def require_user!(_, response)
      return if response[:current_user]

      halt 200, response.render(not_authorized)
    end

    def validate_params!(request, _response)
      raise BadRequestError unless request.params.valid?
    end

    def handle_bad_request(_request, response, _exception)
      response.render(error, code: 400)
      response.status = 400
    end

    def handle_not_found(_request, response, _exception)
      response.render(error, code: 404)
      response.status = 404
    end

    def handle_standard_error(request, response, exception)
      if Hanami.env?(:development) || Hanami.env?(:test)
        raise exception
      else
        sentry.capture_exception(exception) do |scope|
          scope.set_rack_env(request.env)
        end
        response.render(error, code: 500)
        response.status = 500
      end
    end

    def check_host!(request, response)
      return if Hanami.env?(:test)

      response.redirect_to("//#{settings.host}") unless request.host == settings.host
    end
  end
end
