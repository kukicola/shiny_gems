# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :gems do
      add_column :pushed_at, DateTime
      set_column_allow_null :stars
      set_column_allow_null :downloads
    end
  end
end
