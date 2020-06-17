require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/input_proxy'

module Glimmer
  module DSL
    module Opal
      class ButtonExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::InputProxy.new(parent, args)
        end
      end
    end
  end
end
