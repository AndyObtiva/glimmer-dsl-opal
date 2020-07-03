require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/swt/grid_layout_proxy'

module Glimmer
  module DSL
    module Opal
      class GridLayoutExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::GridLayoutProxy.new(parent, args)
        end
      end
    end
  end
end
