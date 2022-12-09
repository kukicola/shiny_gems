# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Users < ROM::Relation[:sql]
        schema(:users, infer: true)

        struct_namespace Entities
        auto_struct true
      end
    end
  end
end
