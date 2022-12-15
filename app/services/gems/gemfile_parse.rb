# frozen_string_literal: true

module ShinyGems
  module Services
    module Gems
      class GemfileParse < ShinyGems::Service
        def call(content)
          ast = RubyVM::AbstractSyntaxTree.parse(content)
          Success(seek_gems(ast))
        rescue SyntaxError
          Failure(:gemfile_parse_failed)
        end

        private

        def seek_gems(tree)
          if tree.type == :FCALL && tree.children[0] == :gem
            return tree.children[1].children[0].children[0]
          end

          tree.children.map do |child|
            next unless child.is_a?(RubyVM::AbstractSyntaxTree::Node)

            seek_gems(child)
          end.compact.flatten
        end
      end
    end
  end
end
