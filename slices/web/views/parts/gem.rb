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

        def url
          "https://rubygems.org/gems/#{value.name}"
        end
      end
    end
  end
end
