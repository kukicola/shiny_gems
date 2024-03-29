# frozen_string_literal: true

module Web
  module Actions
    module Gemfile
      class Create < Web::Action
        include Deps["services.gemfile_parser", "errors_mapper", "repositories.gems_repository"]

        def handle(request, response)
          result = gemfile_parser.call(request.params[:gemfile][:tempfile].read)

          if result.success?
            response[:gems] = gems_repository.by_list(result.value!)
          else
            response.flash[:warning] = errors_mapper.call(result.failure)
            response.redirect_to("/gems")
          end
        end
      end
    end
  end
end
