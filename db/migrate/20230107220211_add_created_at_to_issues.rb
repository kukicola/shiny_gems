# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :issues do
      add_column :created_at, DateTime
    end
  end
end
