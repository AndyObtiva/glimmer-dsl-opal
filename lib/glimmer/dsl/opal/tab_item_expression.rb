require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/tab_item'

module Glimmer
  module DSL
    module Opal
      class TabItemExpression < StaticExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::TabItem.new(parent, args)
        end
      end
    end
  end
end
