# frozen_string_literal: true

require "rspec-sidekiq"

Sidekiq.configure_client do |config|
  config.logger.level = Logger::WARN
end
