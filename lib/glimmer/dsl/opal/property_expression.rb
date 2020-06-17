require 'glimmer/dsl/expression'

module Glimmer
  module DSL
    module Opal
      class PropertyExpression < StaticExpression
        include TopLevelExpression

        def can_interpret?(parent, keyword, *args, &block)          
          parent and keyword and block.nil?
        end

        def interpret(parent, keyword, *args, &block)
          parent.send(keyword + '=', args.first.to_s)
          args.first.to_s
        end
      end
    end
  end
end
