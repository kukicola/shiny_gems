# memoize: true
# frozen_string_literal: true

module Web
  module Repositories
    class GemsRepository < ROM::Repository[:gems]
      include Deps[container: "persistence.rom"]

      SORT = {
        "downloads" => proc { `downloads DESC` },
        "stars" => proc { `stars DESC` },
        "name" => proc { `name ASC` },
        "issues_count" => proc { `issues_count DESC` },
        "recent_issues" => proc { `max_issue_created_at DESC` },
        "favorites" => proc { `favorites_count DESC NULLS LAST` }
      }

      auto_struct true

      def by_id(id, with: nil)
        query = gems.by_pk(id)
        query = query.combine(with) if with
        query.one
      end

      def by_name(name, with: nil)
        query = gems.where(name: name)
        query = query.combine(with) if with
        query.one
      end

      def index(per_page: 20, page: 1, order: "downloads")
        base_query
          .per_page(per_page)
          .page(page)
          .order(&SORT[order])
      end

      def by_list(items)
        base_query.where(gems[:name] => items)
      end

      def random(limit)
        base_query.order { `RANDOM()` }.limit(limit)
      end

      def user_favorites(user_id)
        base_query
          .join(favorites)
          .where(favorites[:user_id] => user_id)
          .order(&SORT["name"])
      end

      private

      def base_query
        # plain Sequel datasets for CTE
        new_ds = gems.dataset.with(:ic, issues_count).with(:fc, favorites_count)
        gems.class.new(new_ds).with(auto_struct: true)
          .select_append { `ic.count`.as(:issues_count) }
          .select_append { `fc.count`.as(:favorites_count) }
          .select_append { `ic.max_created_at`.as(:max_issue_created_at) }
          .join(repos)
          .join(:ic, {repo_id: repos[:id]})
          .left_join(:fc, {gem_id: gems[:id]})
          .where { pushed_at > DateTime.now - 365 }
          .combine(:repo)
      end

      def issues_count
        container.relations[:issues].dataset.unordered
          .select(
            :repo_id,
            Sequel.function(:count, "*").as(:count),
            Sequel.function(:max, :created_at).as(:max_created_at)
          )
          .group(:repo_id)
      end

      def favorites_count
        container.relations[:favorites].dataset.unordered.group_and_count(:gem_id)
      end
    end
  end
end
