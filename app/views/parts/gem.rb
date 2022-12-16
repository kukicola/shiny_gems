# frozen_string_literal: true

module ShinyGems
  module Views
    module Parts
      class Gem < Hanami::View::Part
        include Deps["formatter"]

        def stars
          formatter.separator(value.stars)
        end

        def downloads
          formatter.separator(value.downloads)
        end

        def repo_url
          "https://github.com/#{value.repo}"
        end
      end
    end
  end
end
