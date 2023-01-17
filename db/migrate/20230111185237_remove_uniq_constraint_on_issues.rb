# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :issues do
      drop_index(:github_id)
      add_unique_constraint([:gem_id, :github_id])
    end
  end
end
