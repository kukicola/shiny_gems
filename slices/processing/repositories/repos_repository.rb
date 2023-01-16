# frozen_string_literal: true

module Processing
  module Repositories
    class ReposRepository < ROM::Repository[:repos]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk, delete: :by_pk
      auto_struct true

      def by_id(id, with: nil)
        query = repos.by_pk(id)
        query = query.combine(with) if with
        query.one
      end

      def pluck_ids_for_hour(hour)
        repos.where(Sequel.lit("id % 24 = ?", hour)).pluck(:id)
      end

      def find_or_create(attributes)
        existing = repos.where(attributes).one
        return existing if existing

        create(attributes)
      end
    end
  end
end
