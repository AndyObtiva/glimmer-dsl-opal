require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/div_proxy'

module Glimmer
  module DSL
    module Opal
      class CompositeExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::DivProxy.new(parent, args)
        end
      end
    end
  end
end
