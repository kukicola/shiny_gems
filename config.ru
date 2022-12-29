# frozen_string_literal: true

require "hanami/boot"

OmniAuth.config.request_validation_phase = ShinyGems::Action.new
run Hanami.app
