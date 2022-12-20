# frozen_string_literal: true

OmniAuth.config.test_mode = true
OmniAuth.config.request_validation_phase = false
OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: "github",
  uid: 235352,
  info: {
    nickname: "test",
    image: "http://localhost/avatar.png"
  },
  credentials: {
    token: "abc"
  }
})
