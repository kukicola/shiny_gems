# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Gems < ROM::Relation[:sql]
        use :pagination

        schema(:gems, infer: true) do
          associations do
            belongs_to :repo
          end
        end
      end
    end
  end
end
