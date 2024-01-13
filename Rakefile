# frozen_string_literal: true

require "hanami/rake_tasks"
require "rom/sql/rake_task"

Rake::Task["assets:precompile"].clear
namespace :assets do
  namespace :precompile do
    Hanami::CLI::Commands::App::Assets::Compile.new.call
  end
end

Dir.glob("lib/tasks/**/*.rake").each { |r| load r }
