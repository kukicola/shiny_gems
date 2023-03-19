# frozen_string_literal: true

Factory.define(:user) do |f|
  f.username "testname"
  f.sequence(:github_id) { |n| 1000 + n }
  f.email "test@test.com"
  f.avatar "http://localhost/avatar.png"
end
