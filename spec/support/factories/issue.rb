# frozen_string_literal: true

Factory.define(:issue, struct_namespace: ShinyGems::Entities) do |f|
  f.sequence(:title) { |n| "Some issue #{n}" }
  f.sequence(:url) { |n| "https://github.com/repo/gem/issues/#{n}" }
  f.sequence(:github_id) { |n| 1000 + n }
  f.comments 5
  f.association(:gem)
  f.labels { [{"name" => "test", "color" => "dddddd"}] }
end
