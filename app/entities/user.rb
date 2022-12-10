# frozen_string_literal: true

module ShinyGems
  module Entities
    class User < ROM::Struct
      def github_token
        Hanami.app["lockbox"].decrypt(github_token_encrypted)
      end
    end
  end
end
