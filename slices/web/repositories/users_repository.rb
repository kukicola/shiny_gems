# memoize: true
# frozen_string_literal: true

module Web
  module Repositories
    class UsersRepository < ROM::Repository[:users]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk
      auto_struct true

      def by_id(id)
        users.by_pk(id).one
      end

      def auth(auth_hash)
        info = auth_hash.info
        attrs = {
          github_id: auth_hash.uid,
          username: info["nickname"],
          avatar: info["image"],
          email: info["email"]
        }

        if (user = users.where(github_id: attrs[:github_id]).one)
          update(user.id, attrs)
        else
          create(attrs)
        end
      end
    end
  end
end
