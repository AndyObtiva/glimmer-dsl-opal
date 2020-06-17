require 'glimmer/dsl/expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/input_proxy'

module Glimmer
  module DSL
    module Opal
      class TextExpression < Expression
        include ParentExpression

        def can_interpret?(parent, keyword, *args, &block)
          keyword == 'text' and parent and block_given?
        end

        def interpret(parent, keyword, *args, &block)
          args << {type: 'text'}
          Glimmer::Opal::InputProxy.new(parent, args)
        end
      end
    end
  end
end
