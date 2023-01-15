# frozen_string_literal: true

Factory.define(:repo) do |f|
  f.sequence(:name) { |n| "repo/gem#{n}" }
  f.stars { 1521 }
  f.association(:issues, count: 3)
  f.pushed_at { DateTime.now - 30 }
  f.association(:gems, count: 0)
end
