# frozen_string_literal: true

module ShinyGems
  module Repositories
    class Gems < ROM::Repository[:gems]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk
      struct_namespace ::ShinyGems::Entities
      auto_struct true

      def by_id(id)
        gems.by_pk(id).one
      end
    end
  end
end
