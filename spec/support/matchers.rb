# frozen_string_literal: true

RSpec::Matchers.define :match_entity do |expected|
  match do |actual|
    filtered(actual) == filtered(expected)
  end

  def filtered(entity)
    entity.attributes.reject { |_, value| value.is_a?(ROM::Struct) || (value.is_a?(Array) && value.all? { |el| el.is_a?(ROM::Struct) }) }
  end
end
