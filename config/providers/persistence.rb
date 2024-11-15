# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    config = ROM::Configuration.new(:sql, target["settings"].database_url, max_connections: 10, sslmode: "disable")

    register "config", config
    register "db", config.gateways[:default].connection
  end

  start do
    config = target["persistence.config"]

    config.auto_registration(
      target.root.join("lib/shiny_gems/persistance"),
      namespace: "ShinyGems::Persistence"
    )

    container = ROM.container(config)
    container.gateways[:default].use_logger(target["logger"]) if Hanami.env?(:development)
    register "rom", container
  end
end
