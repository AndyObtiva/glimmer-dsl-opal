require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/swt/display_proxy'

module Glimmer
  module DSL
    module Opal
      class AsyncExecExpression < StaticExpression
        include TopLevelExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::DisplayProxy.instance.async_exec(&block)
        end
      end
    end
  end
end
