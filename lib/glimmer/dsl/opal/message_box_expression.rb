require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/swt/message_box_proxy'

module Glimmer
  module DSL
    module Opal
      class MessageBoxExpression < StaticExpression
        include TopLevelExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
          parent = args.delete_at(0)
          Glimmer::SWT::MessageBoxProxy.new(parent, args)
        end
      end
    end
  end
end
