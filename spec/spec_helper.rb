# frozen_string_literal: true

require "pathname"
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"

require_relative "support/cov"
require "hanami/prepare"
require "dry/system/stubs"
require "ostruct"

Web::Slice.container.enable_stubs!

RSpec.configure do |config|
  config.after do
    Web::Slice.container.unstub
  end
end

require_relative "support/rspec"
require_relative "support/database_cleaner"
require_relative "support/factory"
require_relative "support/capybara"
require_relative "support/sidekiq"
require_relative "support/matchers"
require_relative "support/fake_repositories"
require_relative "support/webmock"
require_relative "support/csrf_fix"
require_relative "support/omniauth_mock"
require_relative "support/auth"
