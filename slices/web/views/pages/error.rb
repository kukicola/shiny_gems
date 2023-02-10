# frozen_string_literal: true

module Web
  module Views
    module Pages
      class Error < Web::View
        config.template = "pages/error"
        config.title = "Error - ShinyGems"

        expose :code
        expose :msg do |code:|
          Hanami::Http::Status.message_for(code)
        end
      end
    end
  end
end
