# frozen_string_literal: true

Hanami.app.register_provider :gems_api do
  prepare do
    require "gems"
  end

  start do
    register "gems_api", ::Gems
  end
end
