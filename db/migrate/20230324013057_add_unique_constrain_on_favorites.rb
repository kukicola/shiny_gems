# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table :favorites do
      add_index([:gem_id, :user_id], unique: true)
    end
  end
end
