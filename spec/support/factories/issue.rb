# frozen_string_literal: true

Factory.define(:issue) do |f|
  f.sequence(:title) { |n| "Some issue #{n}" }
  f.sequence(:url) { |n| "https://github.com/repo/gem/issues/#{n}" }
  f.sequence(:github_id) { |n| 1000 + n }
  f.comments 5
  f.labels { [{"name" => "test", "color" => "dddddd"}] }
  f.created_at { DateTime.now }

  f.trait :with_repo do |t|
    t.association(:repo)
  end
end
