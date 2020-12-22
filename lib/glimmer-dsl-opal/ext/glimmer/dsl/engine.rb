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
          if keyword == 'shell'
            Document.ready?(&work)
          elsif keyword == 'message_box'
            if Glimmer::SWT::DisplayProxy.instance.shells.empty?
              Document.ready?(&work)
              Glimmer::SWT::LatestMessageBoxProxy.new
            else
              work.call
            end
          else
            work.call
          end
        end
      end
    end
  end
end
