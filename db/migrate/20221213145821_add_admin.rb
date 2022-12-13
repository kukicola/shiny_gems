# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table(:users) do
      add_column :admin, TrueClass, default: false, null: false
    end
  end
end
