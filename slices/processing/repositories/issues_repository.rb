# frozen_string_literal: true

module Processing
  module Repositories
    class IssuesRepository < ROM::Repository[:issues]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk, delete: :by_pk
      auto_struct true

      def replace_repo(old_id, new_id)
        issues.where(repo_id: old_id).update(repo_id: new_id)
      end
    end
  end
end
