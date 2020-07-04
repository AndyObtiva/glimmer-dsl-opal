require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/swt/shell_proxy'

module Glimmer
  module DSL
    module Opal
      class ShellExpression < StaticExpression
        include TopLevelExpression
        include ParentExpression

        def interpret(parent, keyword, *args, &block)
#           Document.ready? do
            Glimmer::SWT::ShellProxy.new(*args)
#           end
        end
      end
    end
  end
end
