# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module ShinyGems
  class Action < Hanami::Action
    before :set_current_user

    private

    def set_current_user(request, response)
      return unless view_context

      user_id = request.session[:user_id]
      response[:current_user] = user_id && Hanami.app["repositories.users_repository"].by_id(user_id)
    end

    def require_user!(_, response)
      return if response[:current_user]

      response.flash[:warning] = "You need to sign in first"
      response.redirect_to("/")
    end
  end
end
