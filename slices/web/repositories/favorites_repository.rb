# memoize: true
# frozen_string_literal: true

module Web
  module Repositories
    class FavoritesRepository < ROM::Repository[:favorites]
      include Deps[container: "persistence.rom"]

      commands :create, delete: :by_pk
      auto_struct true

      def favorite?(user_id:, gem_id:)
        favorites.exist?(user_id: user_id, gem_id: gem_id)
      end

      def total_favorites(gem_id)
        favorites.where(gem_id: gem_id).count
      end

      def unlink(user_id:, gem_id:)
        favorites.where(user_id: user_id, gem_id: gem_id).delete
      end
    end
  end
end
