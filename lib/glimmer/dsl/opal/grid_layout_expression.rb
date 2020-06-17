require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/grid_layout_proxy'

module Glimmer
  module DSL
    module Opal
      class GridLayoutExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::GridLayoutProxy.new(parent, args)
        end
      end
    end
  end
end
