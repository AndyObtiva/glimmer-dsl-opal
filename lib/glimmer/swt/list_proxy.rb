require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class ListProxy < WidgetProxy
      ITEM_EMPTY = '_____'
      attr_reader :items, :selection
      
      def initialize(parent, args)        
        super(parent, args)
        @selection = []
      end
      
      def items=(items)
        @items = items.map {|item| item.strip == '' ? ITEM_EMPTY : item}
        redraw # consider repopulating li's instead of redrawing when li's are available.
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
                if event.target.prop('nodeName') == 'LI'
                  selected_item = event.target.text
                  select(index_of(selected_item), event.meta_key)
                  event_listener.call(event)              
                end
              }
            }
          }
        }
      end
      
      def element
        'ul'
      end
      
      def dom
        list_items = @items
        list_id = id
        list_style = css
        list_selection = selection
        @dom ||= html {
          ul(id: list_id, class: name, style: list_style) {
            list_items.to_a.each_with_index do |item, index|
              li_class = ''
              li_class += ' selected' if list_selection.include?(item)
              li_class += ' empty-list-item' if item == ITEM_EMPTY
              li(class: li_class) {
                item
              }
            end
            nil #TODO   look into glimmer-dsl-xml and why it doesn't ignore collections like each_with_index
          }
        }.to_s
      end
    end
  end
end
