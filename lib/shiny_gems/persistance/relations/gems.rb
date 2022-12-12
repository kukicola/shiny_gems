# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Gems < ROM::Relation[:sql]
        schema(:gems, infer: true) do
          associations do
            belongs_to :user
          end
        end
      end
    end
  end
end
