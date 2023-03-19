# frozen_string_literal: true

module Web
  module Actions
    module Session
      class Create < Web::Action
        include Deps["repositories.users_repository"]

        def handle(request, response)
          user = users_repository.auth(request.env["omniauth.auth"])
          response.session[:user_id] = user.id
          response.flash[:success] = "Successfully signed in"
          response.redirect_to("/")
        end
      end
    end
  end
end
