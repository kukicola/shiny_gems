# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :gems do
      primary_key :id
      column :name, String, null: false, index: {unique: true}
      column :repo, String, null: false
      column :description, String, text: true
      column :stars, Integer, null: false
      column :downloads, Integer, null: false
      foreign_key :user_id, :users
    end
  end
end
