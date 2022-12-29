# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    config = ROM::Configuration.new(:sql, target["settings"].database_url, max_connections: 10)

    register "config", config
    register "db", config.gateways[:default].connection
  end

  start do
    config = target["persistence.config"]

    config.auto_registration(
      target.root.join("lib/shiny_gems/persistance"),
      namespace: "ShinyGems::Persistence"
    )

    target.config.component_dirs.add("lib/shiny_gems/repositories") do |dir|
      dir.namespaces.add_root(key: "repositories", const: "ShinyGems::Repositories")
      dir.auto_register = true
    end

    register "rom", ROM.container(config)
  end
end
