# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module Web
  class Action < Hanami::Action
    include Deps["sentry", "settings"]

    BadRequestError = Class.new(StandardError)
    NotFoundError = Class.new(StandardError)

    handle_exception NotFoundError => :handle_not_found
    handle_exception BadRequestError => :handle_bad_request
    handle_exception StandardError => :handle_standard_error

    before :check_host!

    private

    def validate_params!(request, _response)
      raise BadRequestError unless request.params.valid?
    end

    def handle_bad_request(_request, _response, _exception)
      halt 400
    end

    def handle_not_found(_request, _response, _exception)
      halt 404
    end

    def handle_standard_error(request, _response, exception)
      if Hanami.env?(:development)
        raise exception
      else
        sentry.capture_exception(exception) do |scope|
          scope.contexts[:request] = request.env
        end
        halt 500
      end
    end

    def check_host!(request, response)
      return if Hanami.env?(:test)

      response.redirect_to("//#{settings.host}") unless request.host == settings.host
    end
  end
end
