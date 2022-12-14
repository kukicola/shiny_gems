# frozen_string_literal: true

# TODO: specs

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
      end
    end
  end
end
