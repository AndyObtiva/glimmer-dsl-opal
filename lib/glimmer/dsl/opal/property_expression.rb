require 'glimmer/dsl/expression'

module Glimmer
  module DSL
    module Opal
      class PropertyExpression < StaticExpression
        include TopLevelExpression

        def can_interpret?(parent, keyword, *args, &block)          
          parent and 
            parent.respond_to?(:set_attribute) and 
            keyword and 
            block.nil?
        end

        def interpret(parent, keyword, *args, &block)
          if keyword == 'text' # TODO move into property converters in element proxy
            args = [args.first.to_s.gsub('&', '')]
          end
          parent.set_attribute(keyword, *args)
          args.first.to_s
        end
      end
    end
  end
end
