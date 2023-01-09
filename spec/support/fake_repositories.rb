# frozen_string_literal: true

module ShinyGems
  module Support
    module FakeRepositories
      def fake_repository(namespace, name, &block)
        instance_double("#{namespace.capitalize}::Repositories::#{name.capitalize}Repository").tap do |double|
          block&.call(double)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include ShinyGems::Support::FakeRepositories
end
