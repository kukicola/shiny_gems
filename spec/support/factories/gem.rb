# frozen_string_literal: true

Factory.define(:gem) do |f|
  f.sequence(:name) { |n| "gem#{n}" }
  f.description "This is a gem"
  f.downloads { 2453432 }
  f.association(:repo)
end
