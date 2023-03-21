# frozen_string_literal: true

module Web
  module Repositories
    class FavoritesRepository < ROM::Repository[:favorites]
      include Deps[container: "persistence.rom"]

      commands :create, delete: :by_pk
      auto_struct true
    end
  end
end
