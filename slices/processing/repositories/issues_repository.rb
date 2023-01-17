# frozen_string_literal: true

module Processing
  module Repositories
    class IssuesRepository < ROM::Repository[:issues]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk, delete: :by_pk
      auto_struct true
    end
  end
end
