# frozen_string_literal: true

module Web
  module Views
    class Context < Hanami::View::Context
      def current_user
        response[:current_user]
      end
    end
  end
end
