# auto_register: false
# frozen_string_literal: true

module Cron
  class Worker
    include Sidekiq::Job

    sidekiq_options retry: 10
  end
end
