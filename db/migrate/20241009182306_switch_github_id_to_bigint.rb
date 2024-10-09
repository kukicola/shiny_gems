# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :issues do
      set_column_type :github_id, "bigint"
    end
  end
end
