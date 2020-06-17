require 'glimmer/dsl/expression'

module Glimmer
  module DSL
    module Opal
      class WidgetListenerExpression < Expression

        def can_interpret?(parent, keyword, *args, &block)          
          keyword.start_with?('on_') and args.empty? and block_given?
        end

        def interpret(parent, keyword, *args, &block)
          parent.handle_observation_request(keyword, &block)
        end
      end
    end
  end
end
