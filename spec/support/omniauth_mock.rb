# frozen_string_literal: true

require "omniauth"

OmniAuth.config.test_mode = true
OmniAuth.config.request_validation_phase = false
OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: "github",
  uid: 235352,
  info: {
    nickname: "test",
    image: "http://localhost/avatar.png",
    email: "test@test.com"
  },
  credentials: {
    token: "abc"
  }
})
