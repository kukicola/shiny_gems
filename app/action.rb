# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module ShinyGems
  class Action < Hanami::Action
    include Deps["repositories.users_repository", "repositories.gems_repository"]

    ForbiddenError = Class.new(StandardError)
    BadRequestError = Class.new(StandardError)
    NotFoundError = Class.new(StandardError)

    handle_exception NotFoundError => :handle_not_found
    handle_exception ForbiddenError => :handle_forbidden
    handle_exception BadRequestError => :handle_bad_request

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
  end
end
