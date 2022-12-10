# frozen_string_literal: true

Factory.define(:user, struct_namespace: ShinyGems::Entities) do |f|
  f.username "testname"
  f.github_id "123142"
  f.github_token_encrypted "cvTvQ3SwDxhf7ILAxLVLPd6IbsezZ5mSVmeNVChPzQ=="
  f.avatar "http://localhost/avatar.png"
end
