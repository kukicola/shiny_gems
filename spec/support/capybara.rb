# frozen_string_literal: true

require "capybara/rspec"
require "capybara/cuprite"

Capybara.app = Hanami.app
Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], browser_options: {"disable-smooth-scrolling" => true})
end
