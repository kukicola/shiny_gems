# frozen_string_literal: true

module ShinyGems
  module Support
    module FakeRepositories
      def fake_repository(namespace, name, stub_container: false, &block)
        instance_double("#{namespace.capitalize}::Repositories::#{name.capitalize}Repository").tap do |double|
          block&.call(double)
          Object.const_get("#{namespace.capitalize}::Slice").container.stub("repositories.#{name}_repository", double) if stub_container
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include ShinyGems::Support::FakeRepositories
end
