require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/opal/tab_folder'

module Glimmer
  module DSL
    module Opal
      class TabFolderExpression < StaticExpression
        include ParentExpression
        
        def interpret(parent, keyword, *args, &block)
          Glimmer::Opal::TabFolder.new(parent, args)
        end
      end
    end
  end
end
