# frozen_string_literal: true

module ShinyGems
  module Entities
    class Label < ROM::Struct
      transform_keys(&:to_sym)

      attribute :name, ShinyGems::Types::String
      attribute :color, ShinyGems::Types::String

      def bg_color
        "##{color}"
      end

      def bg_light?
        r, g, b = color.chars.each_slice(2).map(&:join).map(&:hex)
        (0.2126 * r) + (0.7152 * g) + (0.0722 * b) >= 128
      end
    end
  end
end
