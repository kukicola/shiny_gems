# auto_register: false
# frozen_string_literal: true

require "dry/monads"

module Core
  class Service
    include Dry::Monads[:result, :maybe, :do]
  end
end
