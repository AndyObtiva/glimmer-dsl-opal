require 'glimmer/data_binding/observable_element'
require 'glimmer/opal/event_listener_proxy'

module Glimmer
  module Opal
    class SelectProxy
      include Glimmer::DataBinding::ObservableElement
      attr_reader :text, :items
      
      OBSERVATION_REQUEST_MAPPING = {
        SelectProxy => {
          'on_widget_selected' => 'change'
        }
      }

      def initialize(parent, args)
        @parent = parent
        @args = args
        @parent.add_child(self)
        @items = []
      end
      
      def text=(value)
        puts 'text value'
        puts value
        @text = value
        redraw
      end
      
      def items=(the_items)
        puts 'the items'
        puts the_items
        @items = the_items
        redraw
      end

      def handle_observation_request(keyword, &block)
        event = OBSERVATION_REQUEST_MAPPING[self.class][keyword]
        selector = 'select'        
        delegate = $document.on(event, selector) do |event|
          @text = event.target.value
          block.call(event)
        end
        EventListenerProxy.new(element_proxy: self, event: event, selector: selector, delegate: delegate)
      end
      
      def redraw
        old_dom = @dom
        @dom = nil
        old_dom.replace dom
      end
      
      def dom
        puts 'dom'
        puts @text
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
