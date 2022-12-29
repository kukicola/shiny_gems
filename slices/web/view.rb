# auto_register: false
# frozen_string_literal: true

module Web
  class View < Hanami::View
    DEFAULT_DESCRIPTION = "ShinyGems connects maintainers with passionate developers who want to make ruby ecosystem better."

    setting :title
    setting :description

    config.paths = [File.join(__dir__, "templates")]
    config.layout = "application"
    config.part_namespace = Views::Parts
    config.default_context = Views::Context.new

    expose :seo_title, layout: true do
      config.title || "ShinyGems"
    end

    expose :seo_description, layout: true do
      config.description || DEFAULT_DESCRIPTION
    end
  end
end