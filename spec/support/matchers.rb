# frozen_string_literal: true

RSpec::Matchers.define :match_entity do |expected|
  match do |actual|
    actual.attributes.reject { |_, value| value.is_a?(ROM::Struct) } == expected.attributes.reject { |_, value| value.is_a?(ROM::Struct) }
  end
end
