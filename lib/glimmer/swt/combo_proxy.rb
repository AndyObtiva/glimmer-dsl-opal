require 'glimmer/data_binding/observable_element'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class ComboProxy < WidgetProxy
      include Glimmer::DataBinding::ObservableElement
      attr_reader :text, :items
      
      def initialize(parent, args)
        super(parent, args)
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

      def observation_request_to_event_mapping      
        {
          'on_widget_selected' => {
            event: 'change',
            event_handler: -> (event_listener) {
              -> (event) {
                @text = event.target.value
                event_listener.call(event)              
              }
            }
          }
        }
      end
      
      def dom
        select_text = @text        
        items = @items
        select_id = id
        select_style = css
        select_class = name
        @dom ||= html {
          select(id: select_id, class: select_class, style: select_style) {
            items.to_a.each do |item|
              option_hash = {value: item}
              option_hash[:selected] = 'selected' if select_text == item
              option(option_hash) {
                item
              } 
            end
          }
        }.to_s
      end
    end
  end
end
