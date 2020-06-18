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
      def select(index)
        @select_index = index
        redraw
      end

      def observation_request_to_event_mapping
        {
          'on_widget_selected' => {
            event: 'click',
            event_handler: -> (event_listener) {
              -> (event) {
                puts 'event'
                selected_item = event.target.text
                puts selected_item
                select(index_of(selected_item))
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
        list_style = style
        list_select_index = @select_index
        @dom ||= DOM {
          ul(id: list_id, style: list_style) {
            list_items.to_a.each_with_index do |item, index|
              li_class = ''
              li_class += ' selected-list-item' if index == list_select_index
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
