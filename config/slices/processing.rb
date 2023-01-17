# frozen_string_literal: true

require "sidekiq"

module Processing
  class Slice < Hanami::Slice
    Sidekiq.configure_client do |c|
      c.redis = {url: Hanami.app["settings"].redis_url}
    end

    prepare_container do |container|
      container.config.component_dirs.dir("") do |dir|
        dir.instance = proc do |component|
          if component.key.match?(/workers\./)
            component.loader.constant(component)
          else
            component.loader.call(component)
          end
        end
      end
    end
  end
end
