# frozen_string_literal: true

module Web
  module Repositories
    class GemsRepository < ROM::Repository[:gems]
      include Deps[container: "persistence.rom"]

      SORT = {
        "downloads" => proc { |db| db.gems[:downloads].desc },
        "stars" => proc { |db| db.repos[:stars].desc },
        "name" => proc { |db| db.gems[:name].asc }
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
          .select_append(repos[:stars])
          .join(repos)
          .left_join(:issues, {repo_id: :id})
          .exclude(issues[:id] => nil)
          .distinct
          .combine(:repo)
      end
    end
  end
end
