# frozen_string_literal: true

module ShinyGems
  module Views
    module Parts
      class Issue < Hanami::View::Part
        decorate :labels
      end
    end
  end
end
