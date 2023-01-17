# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :gems do
      drop_column :user_id
    end
    drop_table :users
  end
end
