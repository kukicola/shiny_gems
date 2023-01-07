# frozen_string_literal: true

require "dry/monads"

module ShinyGems
  class Service
    include Dry::Monads[:result, :maybe, :do]
  end
end
