# frozen_string_literal: true

Factory.define(:gem) do |f|
  f.sequence(:name) { |n| "gem#{n}" }
  f.sequence(:repo) { |n| "repo/gem#{n}" }
  f.description "This is a gem"
  f.stars { 1521 }
  f.downloads { 2453432 }
  f.association(:issues, count: 0)
  f.pushed_at { DateTime.now - 30 }

  f.trait :with_issues do |t|
    t.association(:issues, count: 3)
  end
end
