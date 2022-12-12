# frozen_string_literal: true

require "hanami/rake_tasks"
require "rom/sql/rake_task"

task :environment do
  require_relative "config/app"
  require "hanami/prepare"
end

Dir.glob("lib/tasks/**/*.rake").each { |r| load r }
