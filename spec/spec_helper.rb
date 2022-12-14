# frozen_string_literal: true

require "pathname"
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"

require_relative "support/cov"
require "hanami/prepare"

require_relative "support/rspec"
require_relative "support/requests"
require_relative "support/database_cleaner"
require_relative "support/factory"
require_relative "support/omniauth_mock"
require_relative "support/capybara"
require_relative "support/sidekiq"
require_relative "support/auth"
