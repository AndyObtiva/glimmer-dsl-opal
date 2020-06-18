require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/iframe_proxy'

module Glimmer
  module DSL
    module Opal
      class BrowserExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::IframeProxy.new(parent, args)
        end
      end
    end
  end
end
