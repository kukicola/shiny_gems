# frozen_string_literal: true

require "hanami/boot"

OmniAuth.config.request_validation_phase = Auth::Action.new
run Hanami.app
