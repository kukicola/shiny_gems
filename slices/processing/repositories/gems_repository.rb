# frozen_string_literal: true

module Processing
  module Repositories
    class GemsRepository < ROM::Repository[:gems]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk, delete: :by_pk
      auto_struct true

      def by_id(id, with: nil)
        query = gems.by_pk(id)
        query = query.combine(with) if with
        query.one
      end

      def pluck_ids_for_hour(hour)
        gems.where(Sequel.lit("id % 24 = ?", hour)).pluck(:id)
      end

      def pluck_name_by_list(items)
        gems.where(name: items).pluck(:name)
      end

      def replace_repo(old_id, new_id)
        gems.where(repo_id: old_id).update(repo_id: new_id)
      end
    end
  end
end
