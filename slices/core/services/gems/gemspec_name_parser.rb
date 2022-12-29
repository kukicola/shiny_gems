# frozen_string_literal: true

module Core
  module Services
    module Gems
      class GemspecNameParser < Core::Service
        def call(content)
          ast = RubyVM::AbstractSyntaxTree.parse(content)
          Maybe(seek_name(ast)).to_result(:name_not_found_in_gemspec)
        rescue SyntaxError
          Failure(:gemspec_parse_failed)
        end

        private

        def seek_name(tree)
          if tree.type == :ATTRASGN && tree.children[1] == :name=
            return tree.children[2].children[0].children[0]
          end

          tree.children.lazy.map do |child|
            next unless child.is_a?(RubyVM::AbstractSyntaxTree::Node)

            seek_name(child)
          end.find { |elem| elem }
        end
      end
    end
  end
end
