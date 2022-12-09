# frozen_string_literal: true

module ShinyGems
  module Repositories
    class Users < ROM::Repository[:users]
      include Deps[container: "persistence.rom"]

      commands :create, update: :by_pk

      def by_id(id)
        users.by_pk(id).one
      end

      def auth(auth_hash)
        info = auth_hash.info
        attrs = {
          github_id: auth_hash.uid,
          username: info['nickname'],
          email: info['email'],
          avatar: info['image'],
          github_token_encrypted: 'abc'
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
