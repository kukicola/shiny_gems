# frozen_string_literal: true

Processing::Slice.register_provider :gems_api do
  prepare do
    require "gems"
  end

  start do
    register "gems_api", ::Gems
  end
end
