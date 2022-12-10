# frozen_string_literal: true

require "rom-factory"

Factory = ROM::Factory.configure do |config|
  config.rom = Hanami.app["persistence.rom"]
end

Dir[File.dirname(__FILE__) + "/factories/*.rb"].each { |file| require file }
