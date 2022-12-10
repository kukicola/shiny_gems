# frozen_string_literal: true

module ShinyGems
  module Repositories
    class Users < ROM::Repository[:users]
      include Deps["lockbox", container: "persistence.rom"]

      commands :create, update: :by_pk
      struct_namespace ::ShinyGems::Entities
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
          github_token_encrypted: lockbox.encrypt(auth_hash.credentials["token"])
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
