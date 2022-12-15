# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module ShinyGems
  class Action < Hanami::Action
    ForbiddenError = Class.new(StandardError)
    BadRequestError = Class.new(StandardError)

    handle_exception ForbiddenError => :handle_forbidden
    handle_exception BadRequestError => :handle_bad_request

    before :set_current_user

    private

    def set_current_user(request, response)
      user_id = request.session[:user_id]
      response[:current_user] = user_id && Hanami.app["repositories.users_repository"].by_id(user_id)
    end

    def require_user!(_, response)
      return if response[:current_user]

      response.flash[:warning] = "You need to sign in first"
      response.redirect_to("/")
    end

    def load_gem_and_check_ownership!(request, response)
      id = request.params[:id]
      gem = Hanami.app["repositories.gems_repository"].by_id(id, with: [:issues])

      if gem.user_id == response[:current_user].id
        response[:current_gem] = gem
      else
        raise ForbiddenError
      end
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
  end
end
