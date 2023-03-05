# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :gems do
      add_column :version, String
      add_column :licenses, "text[]"
    end
  end
end
