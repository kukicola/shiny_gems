# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

gem "hanami", "~> 2.0"
gem "hanami-router", "~> 2.0"
gem "hanami-controller", "~> 2.0"
gem "hanami-validations", "~> 2.0"
gem "hanami-view", "~> 2.0"
gem "hanami-assets", "~> 2.0"
gem "rom", "~> 5.3"
gem "rom-sql", "~> 3.6"
gem "pg"
gem "octokit"
gem "dry-monads"
gem "gems"
gem "dry-types", "~> 1.7"
gem "puma"
gem "rake"
gem "sidekiq"
gem "faraday-retry"
gem "sentry-ruby"
gem "sentry-sidekiq"
gem "sidekiq-cron"
gem "sequel_pg"
gem "omniauth"
gem "omniauth-github"

group :development, :test do
  gem "dotenv"
  gem "standard"
end

group :cli, :development do
  gem "hanami-reloader"
end

group :cli, :development, :test do
  gem "hanami-rspec"
end

group :development do
  gem "guard-puma", "~> 0.8"
end

group :test do
  gem "rack-test"
  gem "database_cleaner-sequel"
  gem "rom-factory"
  gem "capybara"
  gem "rspec-sidekiq"
  gem "simplecov"
  gem "webmock"
  gem "cuprite"
end
