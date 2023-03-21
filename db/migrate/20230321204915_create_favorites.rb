# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :favorites do
      primary_key :id
      foreign_key :gem_id, :gems, on_delete: :cascade
      foreign_key :user_id, :users, on_delete: :cascade
    end
  end
end
