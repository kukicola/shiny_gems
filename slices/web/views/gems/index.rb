# frozen_string_literal: true

module Web
  module Views
    module Gems
      class Index < Web::View
        config.template = "gems/index"
        config.title = "Browse gems - ShinyGems"

        expose :gems, :pager, :sort_by

        expose :pages, decorate: false do |pager:|
          total = pager.total_pages
          total.times.map { |i| i + 1 }.map do |page|
            next :gap unless page == 1 || page == total || page.between?(pager.current_page - 1, pager.current_page + 1)
            page
          end.chunk(&:itself).map(&:first)
        end
      end
    end
  end
end
