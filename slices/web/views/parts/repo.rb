# frozen_string_literal: true

module Web
  module Views
    module Parts
      class Repo < Hanami::View::Part
        include Deps["formatter"]

        decorate :issues

        def stars
          formatter.separator(value.stars)
        end

        def url
          "https://github.com/#{value.name}"
        end
      end
    end
  end
end
