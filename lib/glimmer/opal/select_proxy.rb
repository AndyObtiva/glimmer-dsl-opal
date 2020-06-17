module Glimmer
  module Opal
    class SelectProxy
      attr_reader :text, :items

      def initialize(parent, args)
        @parent = parent
        @args = args
        @parent.add_child(self)
        @items = []
      end
      
      def text=(value)
        @text = value
        redraw
      end
      
      def items=(the_items)
        @items = the_items
        redraw
      end

      def on_widget_selected(&block)
        @on_widget_selected = block
        $document.on('change', 'select') do |event|
          @text = event.target.value
          @on_widget_selected.call
        end
        @on_widget_selected # TODO return an ElementListener proxy
      end
      
      def redraw
        old_dom = @dom
        @dom = nil
        old_dom.replace dom
      end
      
      def dom
        select_text = @text        
        items = @items
        on_widget_selected = @on_widget_selected
                
        @dom ||= DOM {
          select {
            items.to_a.each do |item|
              option_hash = {value: item}
              option_hash[:selected] = 'selected' if select_text == item
              option(option_hash) {
                item
              } 
            end
          }
        }
      end
    end
  end
end
