# frozen_string_literal: true

module ShinyGems
  module Persistence
    module Relations
      class Repos < ROM::Relation[:sql]
        schema(:repos, infer: true) do
          associations do
            has_many :gems
            has_many :issues
          end
        end
      end
    end
  end
end
