# frozen_string_literal: true

module Processing
  class Slice < Hanami::Slice
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