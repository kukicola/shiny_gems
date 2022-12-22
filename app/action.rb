# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module ShinyGems
  class Action < Hanami::Action
    include Deps["repositories.users_repository", "repositories.gems_repository", "sentry", "settings"]

    ForbiddenError = Class.new(StandardError)
    BadRequestError = Class.new(StandardError)
    NotFoundError = Class.new(StandardError)

    handle_exception NotFoundError => :handle_not_found
    handle_exception ForbiddenError => :handle_forbidden
    handle_exception BadRequestError => :handle_bad_request
    handle_exception StandardError => :handle_standard_error

    before :check_host!
    before :set_current_user

    private

    def set_current_user(request, response)
      user_id = request.session[:user_id]
      response[:current_user] = user_id && users_repository.by_id(user_id)
    end

    def require_user!(_, response)
      return if response[:current_user]

      response.flash[:warning] = "You need to sign in first"
      response.redirect_to("/")
    end

    def validate_params!(request, _response)
      raise BadRequestError unless request.params.valid?
    end

    def handle_forbidden(_request, _response, _exception)
      halt 403
    end

    def handle_bad_request(_request, _response, _exception)
      halt 400
    end

    def handle_not_found(_request, _response, _exception)
      halt 404
    end

    def handle_standard_error(request, _response, exception)
      if Hanami.env?(:development)
        raise exception
      else
        sentry.capture_exception(exception) do |scope|
          scope.contexts[:request] = request.env
        end
        halt 500
      end
    end

    def check_host!(request, response)
      return if Hanami.env?(:test)

      response.redirect_to("//#{settings.host}") unless request.host_with_port == settings.host
    end
  end
end
