# frozen_string_literal: true

require "hanami/rake_tasks"
require "rom/sql/rake_task"

task :environment do
  require_relative "config/app"
  require "hanami/prepare"
end

namespace :assets do
  task precompile: :environment do
    system "bundle exec hanami assets compile"
    exit
  end
end

Dir.glob("lib/tasks/**/*.rake").each { |r| load r }
