# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id
      column :username, String, null: false
      column :github_id, String, null: false
      column :email, String, null: false
      column :github_token_encrypted, String, null: false
      column :avatar, String, null: false
    end
  end
end
