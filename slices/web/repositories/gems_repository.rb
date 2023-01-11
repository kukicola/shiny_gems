# frozen_string_literal: true

module Web
  module Repositories
    class GemsRepository < ROM::Repository[:gems]
      include Deps[container: "persistence.rom"]

      auto_struct true

      def by_id(id, with: nil)
        query = gems.by_pk(id)
        query = query.combine(*with) if with
        query.one
      end

      def index(per_page: 20, page: 1, order: "name", order_dir: "asc")
        base_query
          .per_page(per_page)
          .page(page)
          .order(gems[order.to_sym].send(order_dir.to_sym))
      end

      def by_list(items)
        base_query.where(name: items)
      end

      private

      def base_query
        gems
          .where { pushed_at > DateTime.now - 365 }
          .left_join(:issues)
          .exclude(issues[:id] => nil)
          .distinct
      end
    end
  end
end
