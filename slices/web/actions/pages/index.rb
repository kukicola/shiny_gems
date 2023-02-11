# frozen_string_literal: true

module Web
  module Actions
    module Pages
      class Index < Web::Action
        include Deps["repositories.gems_repository"]

        def handle(request, response)
          response[:random_gems] = gems_repository.random(3)
        end
      end
    end
  end
end
