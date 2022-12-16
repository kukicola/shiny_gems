# frozen_string_literal: true

module ShinyGems
  module Support
    module FakeRepositories
      def fake_repository(name, stub_container: false, &block)
        instance_double("ShinyGems::Repositories::#{name.capitalize}Repository").tap do |double|
          Hanami.app.container.stub("repositories.#{name}_repository", double) if stub_container
          block.call(double) if block
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include ShinyGems::Support::FakeRepositories
end
