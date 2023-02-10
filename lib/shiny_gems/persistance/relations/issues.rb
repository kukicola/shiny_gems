# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Issues < ROM::Relation[:sql]
        schema(:issues, infer: true) do
          associations do
            belongs_to :repo
          end
        end

        def ordered
          order { created_at.desc }
        end
      end
    end
  end
end
