require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/select_proxy'

module Glimmer
  module DSL
    module Opal
      class ComboExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::SelectProxy.new(parent, args)
        end
      end
    end
  end
end
