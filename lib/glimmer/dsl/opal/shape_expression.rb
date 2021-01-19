require 'glimmer/dsl/expression'
require 'glimmer/dsl/parent_expression'

module Glimmer
  module DSL
    module Opal
      class ShapeExpression < Expression
        include ParentExpression
        
        INCLUDED_KEYWORDS = %w[rectangle polygon]
  
        def can_interpret?(parent, keyword, *args, &block)
          INCLUDED_KEYWORDS.include?(keyword)
        end

        def interpret(parent, keyword, *args, &block)
          # TODO
        end
        
        def add_content(parent, &block)
          # TODO
        end
      end
    end
  end
end
