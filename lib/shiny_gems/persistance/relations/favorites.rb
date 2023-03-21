# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Favorites < ROM::Relation[:sql]
        schema(:favorites, infer: true) do
          associations do
            belongs_to :user
            belongs_to :gem
          end
        end
      end
    end
  end
end
