# frozen_string_literal: true

module Web
  module Views
    module Pages
      class NotAuthorized < Web::View
        config.template = "pages/not_authorized"
        config.title = "Sign in - ShinyGems"
      end
    end
  end
end
