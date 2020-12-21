module Glimmer
  module DSL
    class Engine
      class << self
        def interpret_expression(expression, keyword, *args, &block)
          work = lambda do
            expression.interpret(parent, keyword, *args, &block).tap do |ui_object|
              add_content(ui_object, expression, &block)
              dsl_stack.pop
            end
          end
          if keyword.to_s == 'shell'
            Document.ready?(&work)
          else
            work.call
          end
        end
      end
    end
  end
end
