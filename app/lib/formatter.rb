# frozen_string_literal: true

# TODO: specs

module ShinyGems
  class Formatter
    def separator(number)
      num_groups = number.to_s.chars.to_a.reverse.each_slice(3)
      num_groups.map(&:join).join(",").reverse
    end
  end
end
