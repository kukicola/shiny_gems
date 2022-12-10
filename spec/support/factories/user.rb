# frozen_string_literal: true

Factory.define(:user) do |f|
  f.username "testname"
  f.github_id "123142"
  f.email "fake@email.com"
  f.github_token_encrypted "xxx"
  f.avatar "http://localhost/avatar.png"
end
