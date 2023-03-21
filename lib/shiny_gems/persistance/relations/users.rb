# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Users < ROM::Relation[:sql]
        schema(:users, infer: true) do
          associations do
            has_many :favorites
          end
        end
      end
    end
  end
end
