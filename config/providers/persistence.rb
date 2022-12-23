# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    config = ROM::Configuration.new(:sql, target["settings"].database_url, max_connections: 10, extensions: [:connection_validator])

    config.gateways[:default].connection.pool.connection_validation_timeout = 1600

    register "config", config
    register "db", config.gateways[:default].connection
  end

  start do
    config = target["persistence.config"]

    config.auto_registration(
      target.root.join("lib/shiny_gems/persistance"),
      namespace: "ShinyGems::Persistence"
    )

    register "rom", ROM.container(config)
  end
end
