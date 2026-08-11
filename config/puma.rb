# frozen_string_literal: true

max_threads_count = ENV.fetch("HANAMI_MAX_THREADS", 5)
min_threads_count = ENV.fetch("HANAMI_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("HANAMI_PORT", 2300), "0.0.0.0"
environment ENV.fetch("HANAMI_ENV", "development")
workers ENV.fetch("HANAMI_WEB_CONCURRENCY", 2)

preload_app!

# The persistence provider is started while the app is preloaded. Disconnect its
# pool before forking so workers do not inherit and concurrently use the same
# PostgreSQL sockets. Sequel reconnects lazily in each worker on first use.
before_fork do
  Hanami.app["persistence.db"].disconnect
end
