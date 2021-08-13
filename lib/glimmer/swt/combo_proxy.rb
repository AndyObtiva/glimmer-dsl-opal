require 'glimmer/data_binding/observable_element'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class ComboProxy < WidgetProxy
      include Glimmer::DataBinding::ObservableElement
      attr_reader :text, :items
      attr_accessor :selection # virtual attribute just to pass the shine data-binding test (TODO THINK OF A BETTER WAY OF HANDLING THIS)
      
      def initialize(parent, args, block)
        super(parent, args, block)
        @items = []
      end
      
      def element
        'select'
      end
      
      def text=(value)
        @text = value
        Document.find(path).value = value
      end
      
      def items=(the_items)
        @items = the_items
        items_dom = items.to_a.map do |item|
          option_hash = {value: item}
          option_hash[:selected] = 'selected' if @text == item
          html {
            option(option_hash) {
              item
            }
          }.to_s
        end
        dom_element.html(items_dom)
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
          },
          'on_key_pressed' => {
            event: 'keydown',
            event_handler: -> (event_listener) {
              -> (event) {
                @last_key_pressed_event = event
                @text = event.target.value
                # TODO generalize this solution to all widgets that support key presses
                # TODO support event.location once DOM3 is supported by opal-jquery
                event.define_singleton_method(:keyCode) {event.which}
                event.define_singleton_method(:key_code, &event.method(:keyCode))
                event.define_singleton_method(:character) {event.which.chr}
                event.define_singleton_method(:stateMask) do
                  state_mask = 0
                  state_mask |= SWTProxy[:alt] if event.alt_key
                  state_mask |= SWTProxy[:ctrl] if event.ctrl_key
                  state_mask |= SWTProxy[:shift] if event.shift_key
                  state_mask |= SWTProxy[:command] if event.meta_key
                  state_mask
                end
                event.define_singleton_method(:state_mask, &event.method(:stateMask))
                doit = true
                event.define_singleton_method(:doit=) do |value|
                  doit = value
                end
                event.define_singleton_method(:doit) { doit }
                event_listener.call(event)
                
                  # TODO Fix doit false, it's not stopping input
                unless doit
                  event.prevent
                  event.prevent_default
                  event.stop_propagation
                  event.stop_immediate_propagation
                end
                
                doit
              }
            }
          },
        }
      end
      
      def dom
        items = @items
        select_id = id
        select_style = css
        select_class = name
        @dom ||= html {
          select(id: select_id, class: select_class, style: select_style) {
          }
        }.to_s
      end
      
    end
  end
  
end
