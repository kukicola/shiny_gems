# frozen_string_literal: true

Factory.define(:favorite) do |f|
  f.association(:gem)
  f.association(:user)
end
