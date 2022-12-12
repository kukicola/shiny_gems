# frozen_string_literal: true

Factory.define(:gem, struct_namespace: ShinyGems::Entities) do |f|
  f.sequence(:name) { |n| "gem#{n}" }
  f.sequence(:repo) { |n| "repo/gem#{n}" }
  f.description "This is a gem"
  f.stars { 1521 }
  f.downloads { 2453432 }
  f.association(:user)
end
