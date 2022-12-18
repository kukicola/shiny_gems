# frozen_string_literal: true

module ShinyGems
  module Repositories
    class GemsRepository < ROM::Repository[:gems]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk, delete: :by_pk
      struct_namespace ::ShinyGems::Entities
      auto_struct true

      def by_id(id, with: nil)
        query = gems.by_pk(id)
        query = query.combine(*with) if with
        query.one
      end

      def pluck_ids
        gems.pluck(:id)
      end

      def index(per_page: 20, page: 1, order: "name", order_dir: "asc")
        gems
          .left_join(:issues)
          .exclude(issues[:id] => nil)
          .distinct
          .per_page(per_page)
          .page(page)
          .order(gems[order.to_sym].send(order_dir.to_sym))
      end

      def belonging_to_user(user_id)
        gems.order { name.asc }.where(user_id: user_id)
      end
    end
  end
end
