require 'glimmer/dsl/expression'

module Glimmer
  module DSL
    module Opal
      class WidgetListenerExpression < Expression

        def can_interpret?(parent, keyword, *args, &block)          
          keyword.start_with?('on_') and block_given?
        end

        def interpret(parent, keyword, *args, &block)
          parent.send(keyword, &block)
        end
      end
    end
  end
end
