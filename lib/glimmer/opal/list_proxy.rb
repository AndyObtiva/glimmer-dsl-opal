require 'glimmer/opal/element_proxy'

module Glimmer
  module Opal
    class ListProxy < ElementProxy
      ITEM_EMPTY = '_____'
      attr_reader :items, :selection
      
      def initialize(parent, args)
        super(parent, args)
        @selection = []
      end
      
      def items=(items)
        @items = items.map {|item| item.strip == '' ? ITEM_EMPTY : item}
        redraw
      end
      
      def index_of(item)
        @items.index(item)
      end
      
      # used for multi-selection taking an array
      def selection=(selection)
        @selection = selection
        redraw
      end
      
      # used for single selection taking an index
      def select(index, meta = false)
        selected_item = @items[index]
        if @selection.include?(selected_item)
          @selection.delete(selected_item) if meta
        else
          @selection = [] if !meta || (!has_style?(:multi) && @selection.to_a.size >= 1)
          @selection << selected_item
        end
        self.selection = @selection
      end

      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click',
            event_handler: -> (event_listener) {
              -> (event) {                
                selected_item = event.target.text
                select(index_of(selected_item), event.meta?)
                event_listener.call(event)              
              }
            }
          }
        }
      end
      
      def name
        'ul'
      end
      
      def dom
        list_items = @items
        list_id = id
        list_style = css
        list_selection = selection
        @dom ||= DOM {
          ul(id: list_id, style: list_style) {
            list_items.to_a.each_with_index do |item, index|
              li_class = ''
              li_class += ' selected-list-item' if list_selection.include?(item)
              li_class += ' empty-list-item' if item == ITEM_EMPTY
              li(class: li_class) {
                item
              }
            end
          }
        }
      end
    end
  end
end
