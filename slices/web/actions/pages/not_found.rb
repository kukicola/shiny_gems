# frozen_string_literal: true

module Web
  module Actions
    module Pages
      class NotFound < Web::Action
        def handle(_request, _response)
          raise NotFoundError
        end
      end
    end
  end
end
