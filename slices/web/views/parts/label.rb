# frozen_string_literal: true

module Web
  module Views
    module Parts
      class Label < Hanami::View::Part
        def name
          value["name"]
        end

        def bg_color
          "##{value["color"]}"
        end

        def bg_light?
          r, g, b = value["color"].chars.each_slice(2).map(&:join).map(&:hex)
          (0.2126 * r) + (0.7152 * g) + (0.0722 * b) >= 128
        end
      end
    end
  end
end
