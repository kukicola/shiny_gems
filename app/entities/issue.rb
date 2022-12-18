# frozen_string_literal: true

module ShinyGems
  module Entities
    class Issue < ROM::Struct
      def self.attributes(new_schema)
        new_schema[:labels] = ShinyGems::Types::Array.of(ShinyGems::Entities::Label)

        super(new_schema)
      end
    end
  end
end
