
module Glimmer
  module Opal
    class InputProxy
      attr_reader :text
      
      def initialize(parent, args)
        @parent = parent
        @args = args
        @parent.add_child(self)
      end
      
      def text=(value)
        @text = value
        redraw
      end

      def redraw
        old_dom = @dom
        @dom = nil
        old_dom.replace dom
      end

      def on_widget_selected(&block)
        @on_widget_selected = block
        redraw
      end

      def dom
        label_text = @text
        @dom ||= DOM {
          input# type: 'button', value: @text, onchange: @on_widget_selected
        }
      end
    end
  end
end
