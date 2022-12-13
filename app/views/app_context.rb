# frozen_string_literal: true

module ShinyGems
  module Views
    class AppContext < Hanami::View::Context
      def current_user
        response[:current_user]
      end
    end
  end
end
