# frozen_string_literal: true

module Web
  module Views
    module Parts
      class Gem < Hanami::View::Part
        include Deps["formatter"]

        decorate :repo

        def downloads
          formatter.separator(value.downloads)
        end
      end
    end
  end
end
