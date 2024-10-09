# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :gems do
      set_column_type :downloads, "bigint"
    end
  end
end
