# frozen_string_literal: true

module ShinyGems
  module Actions
    module Session
      class Create < ShinyGems::Action
        def handle(request, response)
          # puts request.env['omniauth.auth']
        end
      end
    end
  end
end
