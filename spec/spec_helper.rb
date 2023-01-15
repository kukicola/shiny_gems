# frozen_string_literal: true

require "pathname"
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"

require_relative "support/cov"
require "hanami/prepare"

require_relative "support/rspec"
require_relative "support/database_cleaner"
require_relative "support/factory"
require_relative "support/capybara"
require_relative "support/sidekiq"
require_relative "support/matchers"
require_relative "support/fake_repositories"
require_relative "support/webmock"
require_relative "support/csrf_fix"

# TODO: update rspec
class RSpec::Mocks::VerifyingMethodDouble
  ruby2_keywords :proxy_method_invoked if respond_to?(:ruby2_keywords, true)
end
