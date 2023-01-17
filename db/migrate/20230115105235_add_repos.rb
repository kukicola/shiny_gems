# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :repos do
      primary_key :id
      column :name, String, null: false, index: {unique: true}
      column :stars, Integer
      column :pushed_at, DateTime
    end

    alter_table :gems do
      drop_column :repo
      drop_column :stars
      drop_column :pushed_at
      add_foreign_key :repo_id, :repos, index: true
    end

    alter_table :issues do
      drop_foreign_key :gem_id
      add_foreign_key :repo_id, :repos, index: true
      add_index :github_id, unique: true
    end
  end
end
