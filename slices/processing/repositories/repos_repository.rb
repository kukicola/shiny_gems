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

      def pluck_ids
        repos.pluck(:id)
      end
    end
  end
end
