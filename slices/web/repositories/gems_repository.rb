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
        "recent_issues" => proc { `max_issue_created_at DESC` }
      }

      auto_struct true

      def by_id(id, with: nil)
        query = gems.by_pk(id)
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

      private

      def base_query
        gems
          .where { pushed_at > DateTime.now - 365 }
          .select_append { function(:max, `repos.stars`).as(:stars) }
          .select_append { function(:count, `issues.id`).as(:issues_count) }
          .select_append { function(:max, `issues.created_at`).as(:max_issue_created_at) }
          .join(repos)
          .join(:issues, {repo_id: :id})
          .group(gems[:id])
          .combine(:repo)
      end
    end
  end
end
