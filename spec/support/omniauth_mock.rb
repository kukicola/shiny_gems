OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: "github",
  uid: "235352",
  info: {
    nickname: "test",
    email: "test@email.com",
    image: "http://localhost/avatar.png"
  }
})
