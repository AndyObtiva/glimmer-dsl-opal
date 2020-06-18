require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/list_proxy'

module Glimmer
  module DSL
    module Opal
      class ListExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::ListProxy.new(parent, args)
        end
      end
    end
  end
end