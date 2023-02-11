# frozen_string_literal: true

module Web
  module Views
    module Pages
      class Index < Web::View
        config.template = "pages/index"
        config.title = "ShinyGems - Help maintain your favourite gems and make them shine"

        expose :random_gems
      end
    end
  end
end
