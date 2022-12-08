# auto_register: false
# frozen_string_literal: true

module ShinyGems
  class View < Hanami::View
    # Set common configuration in the shared base view class
    config.paths = [File.join(__dir__, "templates")]
    config.layout = "application"
    # config.part_namespace = View::Parts
    # config.scope_namespace = View::Scopes
  end
end
