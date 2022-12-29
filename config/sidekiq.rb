# frozen_string_literal: true

ENV["HANAMI_SLICES"] ||= "core,cron"

require "sidekiq-cron"
require "sentry-sidekiq"
require "hanami/boot"
