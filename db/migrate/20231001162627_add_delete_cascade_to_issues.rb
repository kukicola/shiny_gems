# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :issues do
      drop_foreign_key :repo_id
      add_foreign_key :repo_id, :repos, index: true, on_delete: :cascade
    end
  end
end
