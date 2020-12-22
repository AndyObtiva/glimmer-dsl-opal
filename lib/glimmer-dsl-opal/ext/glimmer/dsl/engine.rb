require 'glimmer/swt/latest_shell_proxy'
require 'glimmer/swt/latest_message_box_proxy'

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
          if ['shell', 'message_box'].include?(keyword) && Glimmer::SWT::DisplayProxy.instance.send("#{keyword}s").empty?
            Document.ready?(&work)
            Glimmer::SWT.const_get("Latest#{keyword.camelcase(:upper)}Proxy").new
          else
            work.call
          end
        end
      end
    end
  end
end
