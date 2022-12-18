# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :issues do
      primary_key :id
      column :title, String, null: false
      column :url, String, null: false
      column :github_id, Integer, null: false, index: {unique: true}
      column :comments, Integer, null: false
      column :labels, :jsonb, null: false
      foreign_key :gem_id, :gems, on_delete: :cascade
    end
  end
end
